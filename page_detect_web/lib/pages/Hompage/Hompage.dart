import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_detect/bloc/BlocData.dart';
import 'package:flutter/material.dart';
import 'package:page_detect/bloc/DemoBloc.dart';
import 'package:page_detect/pages/Previewpage/Previewpage.dart';
import '../../Widget/CardView.dart';

class HomePage extends StatelessWidget {
  // void initState(BuildContext context) => context.read<EventInitState>().add();
  void handlePicture(BuildContext context) {
    context.read<DemoBlocMap>().add(EventUploadFiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Picture to PDF"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Previewpage())),
              icon: Icon(Icons.preview)),
        ],
      ),
      body: BlocBuilder<DemoBlocMap, BlocImageData>(builder: (context, state) {
        print("objbvjhect");
        var result = state.preLoadList
            .map((ele) => CardView(
                  ele.bytes,
                  ele.editBytes,
                  ele.index,
                  isEdit: true,
                ))
            .toList();

        return ListView.builder(
          itemCount: result.length,
          itemBuilder: (BuildContext context, int index) {
            return result[index];
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => handlePicture(context),
          child: const Icon(Icons.upload_file)),
    );
  }
}
