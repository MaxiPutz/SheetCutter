import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_detect/bloc/BlocData.dart';
import 'package:page_detect/bloc/DemoBloc.dart';

import '../../../Class/ImageInfoData.dart';
import '../../../Class/RectInfo.dart';

class CropPage extends StatefulWidget {
  final Image ele;
  final Uint8List bytes;
  int index;

  double height;

  CropPage({
    super.key,
    required this.ele,
    required this.index,
    required this.height,
    required this.bytes,
  });

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _CropPageState createState() => _CropPageState(height);
}

class _CropPageState extends State<CropPage> {
  static const int _diameter = 5;
  bool isInTL = false;
  bool isInTR = false;
  bool isInBL = false;
  bool isInBR = false;

  late Offset _topLeft;
  late Offset _topRight;
  late Offset _bottomLeft;
  late Offset _bottomRight;
  late double offset;

  _CropPageState(double height) {
    double width = 150;
    _topLeft = Offset(0, 0);
    _topRight = Offset(0, width);
    _bottomLeft = Offset(height, 0);
    _bottomRight = Offset(height, width);
  }

  @override
  void initState() {
    super.initState();
    getImageInfo(widget.ele)?.then((value) {
      offset = value.pixelY / widget.height;
      setState(() {
        const double oU = 0.95;
        const double oD = 1 - oU;

        var h = //400;
            widget.height;

        var s = value.imageRatio;

        _topLeft = Offset(h * s * oD, h * oD);
        _topRight = Offset(h * s * oU, h * oD);
        _bottomLeft = Offset(h * s * oD, h * oU);
        _bottomRight = Offset(h * s * oU, h * oU);
      });
    });
  }

  void check(BuildContext context) {
    context.read<DemoBlocMap>().add(EventCropCorner(
        widget.bytes,
        RectInfo(
                topLeft: _topLeft,
                topRight: _topRight,
                bottomLeft: _bottomLeft,
                bottomRight: _bottomRight)
            .multiply(offset),
        widget.index));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Page"),
      ),
      body: Center(
        child: GestureDetector(
            onPanEnd: ((details) {
              isInTL = false;
              isInTR = false;
              isInBL = false;
              isInBR = false;
            }),
            onPanStart: (details) {
              var distTL = dist(details.localPosition, _topLeft);
              var distTR = dist(details.localPosition, _topRight);
              var distBL = dist(details.localPosition, _bottomLeft);
              var distBR = dist(details.localPosition, _bottomRight);

              double diameter = _diameter * 3;
              if (distTL < diameter) {
                isInTL = true;
              } else if (distTR < diameter) {
                isInTR = true;
              } else if (distBL < diameter) {
                isInBL = true;
              } else if (distBR < diameter) {
                isInBR = true;
              }
            },
            onPanUpdate: ((details) {
              if (isInTL) {
                setState(() {
                  _topLeft += details.delta;
                });
              }
              if (isInTR) {
                setState(() {
                  _topRight += details.delta;
                });
              }
              if (isInBL) {
                setState(() {
                  _bottomLeft += details.delta;
                  print(_bottomLeft);
                });
              }
              if (isInBR) {
                setState(() {
                  _bottomRight += details.delta;
                });
              }
            }),
            child: Stack(
              children: [
                Image(image: widget.ele.image, height: widget.height),
                CustomPaint(painter: CirclePainter(_topLeft)),
                CustomPaint(painter: CirclePainter(_topRight)),
                CustomPaint(painter: CirclePainter(_bottomLeft)),
                CustomPaint(painter: CirclePainter(_bottomRight)),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          check(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Offset offset;

  CirclePainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Offset o = Offset(offset.dx, offset.dy);
    canvas.drawCircle(o, 5, paint);
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}

double dist(Offset a, Offset b) {
  return sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));
}

Future<ImageInfoData>? getImageInfo(Image image) {
  Image im = image;
  Completer<ImageInfoData> completer = Completer<ImageInfoData>();

  im.image
      .resolve((const ImageConfiguration()))
      .addListener(ImageStreamListener((info, synchronousCall) {
    var ratio = info.image.width / info.image.height;
    completer.complete(ImageInfoData(
        pixelX: info.image.width,
        pixelY: info.image.height,
        imageRatio: ratio));
  }));

  return completer.future;
}
