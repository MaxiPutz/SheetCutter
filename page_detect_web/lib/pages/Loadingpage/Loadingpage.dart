import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as p;

class Loadingpage extends StatelessWidget {
  String name;
  p.Document pdf;
  Loadingpage(this.name, this.pdf, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("your pdf is creating"),
      ),
      body: Center(
          child: FutureBuilder(
              future: pdf.save(),
              initialData: const CircularProgressIndicator(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data is Widget) return snapshot.data as Widget;

                return FutureBuilder(
                    future: FileSaver.instance.saveFile(
                        "${this.name}.pdf", snapshot.data as Uint8List, ""),
                    initialData: const CircularProgressIndicator(),
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      if (snapshot.data is! Widget) {
                        print(snapshot.data);

                        Future.delayed(const Duration(seconds: 2))
                            .then((value) => Navigator.pop(context));
                        return Text("Finished ${snapshot.data}");
                      } else {
                        return snapshot.data as Widget;
                      }
                    });
              })),
    );
  }
}
