import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_detect/bloc/DemoBloc.dart';
import 'package:page_detect/pages/Demopage/Demopage.dart';
import 'package:page_detect/pages/Hompage/Hompage.dart';

const double paddingVal = 16;

class Selectpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select the Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(paddingVal),
              child: ElevatedButton(
                onPressed: () {
                  context.read<DemoBlocMap>().add(EventSelectPageInit());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Demopage()));
                },
                child: const Text("go to the Demopage"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingVal),
              child: ElevatedButton(
                onPressed: () {
                  context.read<DemoBlocMap>().add(EventSelectPageInit());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: const Text("Fit your images and download as PDF"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
