import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_detect/Widget/CardView.dart';
import 'package:page_detect/pages/Previewpage/Previewpage.dart';

import '../../bloc/BlocData.dart';
import '../../bloc/DemoBloc.dart';

class Demopage extends StatelessWidget {
  const Demopage({super.key});

  void initState(BuildContext context) {
    context
        .read<DemoBlocMap>()
        .add(DemoInitAsset(context, "assets/index.txt", (BlocImageData())));
  }

  @override
  Widget build(BuildContext context) {
    initState(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demopage"),
      ),
      body: BlocBuilder<DemoBlocMap, BlocImageData>(
        builder: (BuildContext context, state) {
          var result = state.preLoadList
              .map((ele) => CardView(ele.bytes, ele.editBytes, ele.index))
              .toList();

          return ListView.builder(
            itemCount: result.length,
            itemBuilder: (BuildContext context, int index) {
              return result[index];
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.preview),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Previewpage()))),
    );
  }
}
