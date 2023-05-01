import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart';

void main(List<String> args) async {
  final inFile = io.File("karo_ass.jpg");
  sendImageToServer2(inFile, "https://server-ooxa7yxd6a-uc.a.run.app");
}

Future<String> sendImageToServer() async {
  Uri uri = Uri.parse("http://localhost:3000/api");
  var res = await http.post(uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"myKey": "data"}));

  print("object");
  print(res.body);

  print(res.bodyBytes.toString());

  return "res.stream.toString()";
}

Future<io.File> sendImageToServer2(io.File file, String APIURL) async {
  final imageFile = file.readAsBytesSync();

  Uri uri = Uri.parse(APIURL + "/api");
  print(APIURL);
  var req = MultipartRequest("POST", uri);
  req.files.add(MultipartFile.fromBytes("data", imageFile));

  print("is sending");
  final res = await req.send();

  print("finished sending");

  var imgData = res.stream;

  final outFile = io.File("gcloud.jpg");

  await imgData.pipe(outFile.openWrite());

  return outFile;
}
