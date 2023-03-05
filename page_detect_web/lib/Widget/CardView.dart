import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_detect/bloc/DemoBloc.dart';
import 'package:page_detect/pages/CropPage/CropPage.dart';

class CardView extends StatelessWidget {
  final Uint8List ele;
  int index;
  bool? isEdit;
  final Uint8List? editList;
  CardView(this.ele, this.editList, this.index, {super.key, this.isEdit});

  void delelte(BuildContext context) =>
      context.read<DemoBlocMap>().add(DemoEventDelete(index));
  void moveUp(BuildContext context) =>
      context.read<DemoBlocMap>().add(DemoEventUp(index));
  void moveDown(BuildContext context) =>
      context.read<DemoBlocMap>().add(DemoEventDown(index));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Row(
            children: [
              Image.memory(ele, height: 150),
              if (editList != null) Image.memory(editList!, height: 150),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: index != null
                ? Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Text(
                      index.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              children: [
                isEdit == true
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CropPage(
                                        ele: Image.memory(ele),
                                        bytes: ele,
                                        height: 400,
                                        index: index,
                                      )));
                        },
                        icon: Icon(Icons.edit))
                    : Container(),
                IconButton(
                  onPressed: () {
                    delelte(context);
                  },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {
                    moveUp(context);
                  },
                  icon: Icon(Icons.arrow_downward),
                ),
                IconButton(
                  onPressed: () {
                    moveDown(context);
                  },
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
