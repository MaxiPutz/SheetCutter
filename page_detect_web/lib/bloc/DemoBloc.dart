import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:page_detect/Class/RectInfo.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:page_detect/Class/Movie.dart';
import 'package:page_detect/httpRequest/httpRequest.dart';
import 'package:pdf/widgets.dart';

import 'BlocData.dart';

class DemoBloc extends BlocObserver {
  const DemoBloc();
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) {
      print("change");
    }
  }
}

abstract class DemoEvent {}

class DemoEventPreLoad extends DemoEvent {
  BuildContext context;
  Uint8List preLoadData;
  String path;
  DemoEventPreLoad(this.preLoadData, this.path, this.context);
}

class DemoInitAsset extends DemoEvent {
  BuildContext context;
  String indexPath;
  BlocImageData demoBlocData;

  DemoInitAsset(this.context, this.indexPath, this.demoBlocData);
}

class DemoEventImageLoad extends DemoEvent {
  int height;
  int width;
  BlocImagePreLoad preLoad;

  DemoEventImageLoad(this.preLoad, this.height, this.width);
}

class DemoEventUpdateList extends DemoEvent {}

class DemoEventUp extends DemoEvent {
  int index;
  DemoEventUp(this.index);
}

class DemoEventDown extends DemoEvent {
  int index;
  DemoEventDown(this.index);
}

class DemoEventDelete extends DemoEvent {
  int index;
  DemoEventDelete(this.index);
}

class DemoEventInitPreview extends DemoEvent {
  late String title;
  DemoEventInitPreview(Response res) {
    var jsonSting = res.body;
    var data = parseMovies(jsonSting);

    int randomIndex = Random().nextInt(data.length - 1);

    title = data.isNotEmpty ? data[randomIndex].title : "test";
  }

  DemoEventInitPreview.str(this.title);
}

class DemoEventSetPDF extends DemoEvent {}

class EventUploadFiles extends DemoEvent {}

class EventCropCorner extends DemoEvent {
  RectInfo info;
  Uint8List bytes;
  int index;
  EventCropCorner(this.bytes, this.info, this.index);
}

class EventSelectPageInit extends DemoEvent {}

class DemoBlocMap extends Bloc<DemoEvent, BlocImageData> {
  DemoBlocMap() : super(BlocImageData()) {
    on<EventSelectPageInit>((event, emit) => emit(BlocImageData()));
    on<DemoEventUpdateList>((event, emit) => emit(state.snapshot()));

    on<DemoEventPreLoad>(
      (event, emit) {
        int index = state.preLoadList.length;
        var inData = event.preLoadData;

        emit(state.addPreLoadList(BlocImagePreLoad(inData, index, load: true)));

        sendImageToServer(inData).then((value) {
          state.preLoadList[index].editBytes = value;
          state.preLoadList[index].setLoad(false);
          event.context.read<DemoBlocMap>().add(DemoEventUpdateList());
          if (state.preLoadList.length ==
              state.preLoadList
                  .where((element) => !element.getLoad())
                  .toList()
                  .length) {
            event.context.read<DemoBlocMap>().add(DemoEventSetPDF());
          }
        });
      },
    );
    on<DemoInitAsset>((event, emit) {
      rootBundle.loadString(event.indexPath).then((value) {
        var path = event.indexPath.replaceFirst("index.txt", "");

        value.split("\n").map((e) => path + e).forEach((element) {
          rootBundle.load(element).then((value) => event.context
              .read<DemoBlocMap>()
              .add(DemoEventPreLoad(
                  value.buffer.asUint8List(), path, event.context)));
        });
      });
    });

    on<DemoEventDelete>((event, emit) {
      state.preLoadList.removeWhere((element) => element.index == event.index);
      emit(state.setIndexdownAfter(event.index));
    });

    on<DemoEventUp>(
        (event, emit) => emit(state.switchIndexWithNext(event.index)));

    on<DemoEventDown>(
        (event, emit) => emit(state.switchIndexWithPrev(event.index)));

    on<DemoEventInitPreview>((event, emit) {
      emit(state.setDocumentTitle(event.title));
    });

    on<DemoEventSetPDF>((event, emit) {
      if (state.preLoadList.length ==
          state.preLoadList
              .where((element) => !element.getLoad())
              .toList()
              .length) {
        emit(state.setPdf(createPreview(state)));
      }
    });
    on<EventUploadFiles>((event, emit) async {
      var res =
          FilePicker.platform.pickFiles(allowMultiple: true, withData: true);

      var value = await res;

      var files = value!.files;
      for (var file in files) {
        Uint8List bytes = file.bytes!;
        emit(state
            .addPreLoadList(BlocImagePreLoad(bytes, state.preLoadList.length)));
        print(file.name.toString());
      }
    });

    on<EventCropCorner>((event, emit) async {
      print(event.info);
      var value = await sendImageToServerCorner(event.bytes, event.info);
      state.preLoadList[event.index].editBytes = value;
      emit(state.snapshot());
    });
  }
}

pw.Document createPreview(BlocImageData blocData) {
  final editList = blocData.preLoadList;

  final pdf = pw.Document();

  final pdfPages = editList
      .map((e) => pw.MemoryImage(e.editBytes!))
      .toList()
      .forEach((element) {
    pdf.addPage(pw.Page(
      build: (context) => pw.Center(child: pw.Image(element)),
    ));
  });

  return pdf;
}
