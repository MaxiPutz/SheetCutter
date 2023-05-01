import 'dart:async';
import 'dart:isolate';
import 'package:server/isolate/nativeFunction.dart';

class CVArgs {
  String input;
  String output;
  SendPort port;

  CVArgs(this.input, this.output, this.port);
}

Future<void> isolatePageDetect(String inputPath, String outputPath) async {
  var res = Completer();
  var receive = ReceivePort();

  var isolate = Isolate.spawn<CVArgs>((message) {
    pageDetect(message.input, message.output);
    message.port.send("pagededect finished");
  }, CVArgs(inputPath, outputPath, receive.sendPort));

  final value = await isolate;
  //.then((value) async {
  final msg = await receive.first;

  print(msg);
  receive.close();
  value.kill();
  res.complete();
  // });
}

void page(String input, String output) {
  pageDetect(input, output);
}

void cvTest() {
  native_add(3, 5);
}

void runIsolate(String inputPath, String outputPath) {
  var receive = ReceivePort();

  var isolate = Isolate.spawn<CVArgs>((message) {
    printInOut(message.input, message.output);
    message.port.send("dere oida");
  }, CVArgs(inputPath, outputPath, receive.sendPort));

  isolate.then((value) async {
    final msg = await receive.first;

    print(msg);
    receive.close();
    value.kill();
  });
}
