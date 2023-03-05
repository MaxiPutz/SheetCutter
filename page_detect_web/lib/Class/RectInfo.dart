import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shelf_multipart/multipart.dart' as multipart;
import 'package:shelf_multipart/form_data.dart' as form;

class RectInfo {
  Offset topLeft;
  Offset topRight;
  Offset bottomLeft;
  Offset bottomRight;
  late double? _scalar;

  void setScalar(double scalar) {
    this._scalar = scalar;
  }

  RectInfo(
      {required this.topLeft,
      required this.topRight,
      required this.bottomLeft,
      required this.bottomRight});

  @override
  String toString() {
    return 'RectInfo(topLeft: $topLeft, topRight: $topRight, '
        'bottomLeft: $bottomLeft, bottomRight: $bottomRight)';
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_function_declarations_over_variables
    var helper = (Offset ele) => {"x": ele.dx.toInt(), "y": ele.dy.toInt()};

    return ({
      "topLeft": helper(topLeft),
      "topRight": helper(topRight),
      "bottomLeft": helper(bottomLeft),
      "bottomRight": helper(bottomRight)
    });
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  RectInfo multiply(double scalar) {
    return RectInfo(
      topLeft: topLeft * scalar,
      topRight: topRight * scalar,
      bottomLeft: bottomLeft * scalar,
      bottomRight: bottomRight * scalar,
    );
  }
}
