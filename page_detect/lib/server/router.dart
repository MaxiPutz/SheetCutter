import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:page_detect_plugin/page_detect_plugin.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_multipart/multipart.dart';

import 'dart:io' as io;

class Service {
  Handler get handler {
    final router = Router();

    router.post("/api", (Request request) async {
      var uuid = Uuid().v4();
      print(uuid);
      final tempDir =
          "${io.Directory.systemTemp.absolute.path}/"; //${Uuid().v4().toString()}";
      print(tempDir);
      final file = io.File(tempDir + "${uuid}.jpg");
      final outFilePath = (tempDir + "${uuid}oo2.jpg");

      await for (var multi in request.multipartFormData) {
        var data = multi.part;
        await data.pipe(file.openWrite());
      }
      final outFile = io.File(outFilePath);
      //await file.openRead().pipe(outFile.openWrite());
      // print(getVersion());
      await pageDetectIsolate(file.path, outFilePath);
      final bytes =
          // file.readAsBytesSync();
          await outFile.readAsBytes();

      return Response.ok(bytes, headers: {
        io.HttpHeaders.contentTypeHeader: "image/jpg",
      });
    });

    router.post("/cornerApi", (Request request) async {
      var tempPath = io.Directory.systemTemp.absolute.path;

      final inFile = io.File("$tempPath/inFile.jpg");
      final outFile = io.File("$tempPath/outFile.jpg");

      dynamic _corner = null;

      print("the server will work");

      await for (var multi in request.multipartFormData) {
        print(multi.name);
        if (multi.name == "picture") {
          await multi.part.pipe(inFile.openWrite());
        } else if (multi.name == "corners") {
          var data = await multi.part.readString();
          _corner = data;
          print(data);
        }
      }

      late Map<String, int> corner;
      try {
        corner = toMap(_corner);
      } catch (e) {
        return Response.badRequest(body: "no corners found");
      }
      print(corner);

      cvCorner(
          inFile.absolute.path,
          outFile.absolute.path,
          corner["tlx"]!,
          corner["tly"]!,
          corner["trx"]!,
          corner["_try"]!,
          corner["blx"]!,
          corner["bly"]!,
          corner["brx"]!,
          corner["bry"]!);

      print("the server was work");

      return Response.ok(outFile.readAsBytesSync(), headers: {
        io.HttpHeaders.contentTypeHeader: "image/jpg",
      });
    });

    return router;
  }
}

Map<String, int> toMap(String jsonString) {
  final jsonData = jsonDecode(jsonString);
  // ignore: prefer_function_declarations_over_variables
  final helper = (Map<String, dynamic> map) =>
      {"x": map["x"] as int, "y": map["y"] as int};

  final Map<String, int> resultMap = {};

  final topLeft = helper(jsonData["topLeft"]);

  final topRight = helper(jsonData["topRight"]);

  final bottomLeft = helper(jsonData["bottomLeft"]);

  final bottomRight = helper(jsonData["bottomRight"]);

  resultMap["tlx"] = topLeft["x"]!;
  resultMap["tly"] = topLeft["y"]!;
  resultMap["trx"] = topRight["x"]!;
  resultMap["_try"] = topRight["y"]!;
  resultMap["blx"] = bottomLeft["x"]!;
  resultMap["bly"] = bottomLeft["y"]!;
  resultMap["brx"] = bottomRight["x"]!;
  resultMap["bry"] = bottomRight["y"]!;

  print(resultMap);
  return resultMap;
}
