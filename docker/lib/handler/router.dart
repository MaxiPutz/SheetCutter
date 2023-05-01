import 'package:server/isolate/index.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_multipart/multipart.dart';
import 'package:server/isolate/index.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:io' as io;
import 'dart:convert';
import 'package:uuid/uuid.dart';

class Service {
  Handler get handler {
    final router = Router();

    router.post("/api", (Request request) async {
      //final file = io.File("test.jpg");
      //final outFilePath = ("out/${Uuid().v4()}.jpg");

      final tempDir = io.Directory.systemTemp.absolute.path;
      final file = io.File(tempDir + "/test.jpg");
      final outFilePath = (tempDir + "/out.jpg");

      print(file.path);
      print(outFilePath);

      var b = file.openWrite();

      await for (var multi in request.multipartFormData) {
        var data = multi.part;
        await data.pipe(file.openWrite());
      }

      await isolatePageDetect(file.absolute.path, outFilePath);

      final outFile = io.File(outFilePath);
      final bytes = await outFile.readAsBytes();
      return Response.ok(bytes, headers: {
        io.HttpHeaders.contentTypeHeader: "image/jpg",
      });
    });

    return router;
  }
}
