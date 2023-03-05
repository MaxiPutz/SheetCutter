import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_detect/bloc/DemoBloc.dart';
import 'package:page_detect/pages/Hompage/Hompage.dart';
import 'package:page_detect/server/server.dart';
import 'pages/Selectpage/SelectPage.dart';

import 'pages/Demopage/Demopage.dart';

void main(List<String> args) {
  Bloc.observer = DemoBloc();
  runServer();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => DemoBlocMap())],
      child: MaterialApp(home: Selectpage()),
    );
  }
}
