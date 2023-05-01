import 'package:shelf/shelf_io.dart' as shelf_io;
import "package:server/handler/index.dart";
import 'dart:io' as io;

void main(List<String> arguments) async {
  final h = await customHandler();
  final server = await shelf_io.serve(h, io.InternetAddress.anyIPv4, 8080);
}
