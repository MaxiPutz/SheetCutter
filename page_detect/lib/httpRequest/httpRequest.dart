import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:page_detect/Class/RectInfo.dart';

String APIURL = "http://192.168.0.206:8080";

Future<Uint8List> sendImageToServer(Uint8List imageFile) async {
  Uri uri = Uri.parse("$APIURL/api");
  var req = MultipartRequest("POST", uri);
  req.files.add(MultipartFile.fromBytes("data", imageFile));

  final res = await req.send();

  var imgData = await res.stream.toList();
  Uint8List imgList = Uint8List.fromList(imgData.expand((i) => i).toList());

  return imgList;
}

Future<Uint8List> sendImageToServerCorner(
    Uint8List imageFile, RectInfo corners) async {
  Uri uri = Uri.parse("$APIURL/cornerApi");
  var req = MultipartRequest("POST", uri);

  // Add image data
  req.files.add(MultipartFile.fromBytes("picture", imageFile));

  req.fields["corners"] = corners.toJsonString();

  final res = await req.send();

  var imgData = await res.stream.toList();
  Uint8List imgList = Uint8List.fromList(imgData.expand((i) => i).toList());
  return imgList;
}
