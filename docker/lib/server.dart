import 'dart:io';

void getAllPng(String inputDirStr, String outPutDirStr) {
  var inPutDir = Directory(inputDirStr)
      .listSync(recursive: true)
      .where((element) =>
          element.toString().contains("jpg") ||
          element.toString().contains("JPG"))
      .toList();

  var outPutDir = Directory(outPutDirStr);
  print(inPutDir.length);

  // ignore: avoid_function_literals_in_foreach_calls
  List<dynamic> outPut = inPutDir.map((element) {
    var temp = element.toString().split("/");
    var name = temp[temp.length - 1];
    name = name.split(".")[0];
    return (name + ".jpg");
  }).toList();

  for (var i = 0; i < outPut.length; i++) {
    outPut[i] = outPutDir.absolute.path.toString() + i.toString() + outPut[i];
  }

  outPut = outPut.map((e) => File(e)).toList();

  outPut.forEach((element) {
    print(element);
  });

  for (var i = 1; i < outPut.length; i++) {
    try {
      var fileB = File(inPutDir[i].absolute.path.toString()).readAsBytesSync();

      (outPut[i] as File).writeAsBytesSync(fileB);
    } catch (e) {
      print(e);
    }
  }
}

void generateAssteFiles(String path) {
  var dir = Directory(path);
  var allFiles = dir.listSync(recursive: true);

  var file = File(path + "/index.txt");

  var all = allFiles.map((e) => e.path.split(path + "/")[1]).toList();

  file.writeAsStringSync(all.join("\n"));
  print(all);
}
