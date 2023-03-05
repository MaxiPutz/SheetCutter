import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:page_detect_plugin/page_detect_plugin.dart' as p;

var temp =
    "/home/max/workspace/cardTesting/pagedetect/page_detect/assets/10pik_ass.jpg";
var out = "/home/max/Desktop/test18.png";

//tlx: 804, tly: 1328, trx: 2232, _try: 1261, blx: 2265, bly: 3618, brx: 2265, bry: 3618}

void main() {
  p.cvCorner(temp, out, 804, 1328, 2232, 1261, 804, 3600, 2265, 3618);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _pageDetectPlugin = p.PageDetectPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _pageDetectPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Text('Running on: $_platformVersion\n'),
                  Image.memory(
                    io.File(temp).readAsBytesSync(),
                    height: 150,
                  ),
                  Image.memory(
                    io.File(out).readAsBytesSync(),
                    height: 150,
                  ),
                ],
              ),
            ),
            // Text(p.getVersion())
          ],
        ),
      ),
    );
  }
}
