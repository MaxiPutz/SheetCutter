import 'dart:async';
import 'package:page_detect/pages/Loadingpage/Loadingpage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_detect/bloc/BlocData.dart';
import 'package:page_detect/bloc/DemoBloc.dart';
import 'package:http/http.dart' as http;

class Previewpage extends StatelessWidget {
  Previewpage({super.key});

  void initState(BuildContext context) {
    context.read<DemoBlocMap>().add(DemoEventSetPDF());
    var uri =
        Uri.parse("https://www.omdbapi.com/?apikey=ac0e2bc0&s=james%20bond");
    http.get(uri).then((value) =>
        context.read<DemoBlocMap>().add(DemoEventInitPreview(value)));
  }

  @override
  Widget build(BuildContext context) {
    initState(context);

    return BlocBuilder<DemoBlocMap, BlocImageData>(builder: (context, state) {
      final controller = TextEditingController();
      controller.text = state.documentTitle;

      var loadingCount = state.preLoadList
          .where((element) => !element.getLoad())
          .toList()
          .length;

      bool isLoading = state.pdf == null ? true : false;

      var res = state.preLoadList
          .map((e) => e.editBytes)
          .map((ele) => Image.memory(
                ele!,
                height: 300,
              ))
          .toList();
      return Scaffold(
        appBar: AppBar(title: const Text("Previewpage")),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                              value: loadingCount / res.length),
                        )
                      : Container(),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "PDF Name"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => res[index],
                  childCount: res.length),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: isLoading
              ? Theme.of(context).disabledColor
              : Theme.of(context).primaryColor,
          onPressed: isLoading
              ? null
              : () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => Loadingpage(
                              controller.text, state.pdf as pw.Document)));
                },
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Icon(Icons.download),
        ),
      );
    });
  }

  @override
  void dispose() {}
}
