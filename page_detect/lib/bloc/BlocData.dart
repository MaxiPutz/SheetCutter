import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class BlocImageData {
  String documentTitle = "write a name";
  List<BlocImagePreLoad> preLoadList = [];
  pw.Document? pdf = null;

  BlocImageData setPdf(pw.Document document) {
    var res = this.snapshot();
    res.pdf = document;
    return res;
  }

  BlocImageData setDocumentTitle(String title) {
    var res = this.snapshot();
    res.documentTitle = title;
    return res;
  }

  BlocImageData snapshot() {
    var res = BlocImageData();
    res.pdf = this.pdf;
    res.documentTitle = this.documentTitle;
    res.preLoadList = this.preLoadList;
    res.preLoadList.sort((e1, e2) => e1.index - e2.index);
    return res;
  }

  BlocImageData addPreLoadList(BlocImagePreLoad ele) {
    var res = this.snapshot();
    res.preLoadList.add(ele);
    return res;
  }

  BlocImageData addImageDataList(BlocImage ele) {
    var res = this.snapshot();
    return res;
  }

  BlocImageData setIndexdownAfter(int index) {
    var res = this.snapshot();
    for (var i = index; i < res.preLoadList.length; i++) {
      res.preLoadList[i].index = res.preLoadList[i].index - 1;
    }
    return res;
  }

  BlocImageData switchIndexWithNext(int index) {
    print(preLoadList.length);

    var res = this.snapshot();
    if (res.preLoadList.length == index + 1) return res;

    var temp = res.preLoadList[index + 1].copy();
    temp.index--;
    res.preLoadList[index + 1] = res.preLoadList[index];
    res.preLoadList[index + 1].index++;
    res.preLoadList[index] = temp;

    return res;
  }

  BlocImageData switchIndexWithPrev(int index) {
    print(preLoadList.length);

    var res = this.snapshot();
    if (index == 0) return res;

    var temp = res.preLoadList[index - 1].copy();
    temp.index++;
    res.preLoadList[index - 1] = res.preLoadList[index];
    res.preLoadList[index - 1].index--;
    res.preLoadList[index] = temp;
    return res;
  }
}

class BlocImagePreLoad {
  Uint8List bytes;
  int index;
  Uint8List? editBytes;
  bool _load = false;
  BlocImagePreLoad(this.bytes, this.index, {bool? load}) {
    this.editBytes = Uint8List.fromList(this.bytes);
    _load = (load == null ? false : load);
  }

  bool getLoad() => _load;
  bool setLoad(bool load) => _load = load;

  BlocImagePreLoad copy() {
    var res = BlocImagePreLoad(
      Uint8List.fromList(bytes),
      index,
    );

    res.editBytes = Uint8List.fromList(editBytes!);

    return res;
  }
}

class BlocImage {
  BlocImagePreLoad preLoad;
  int width;
  int height;

  BlocImage(this.preLoad, this.width, this.height);

  double getRatio() => width / height;
}
