import 'dart:ffi';
import 'package:ffi/ffi.dart';

final _nativLib = DynamicLibrary.open("lib/isolate/libmylib.so");

typedef cvFunc = Void Function(Pointer<Utf8> input, Pointer<Utf8> output);
typedef Native_AddFunc = Int32 Function(Int32 x, Int32 y);

typedef Native_Add = int Function(int x, int y);
typedef cv = void Function(Pointer<Utf8> intput, Pointer<Utf8> output);

Native_Add native_add =
    _nativLib.lookup<NativeFunction<Native_AddFunc>>("native_add").asFunction();

void printInOut(String input, String output) {
  var inputP = input.toNativeUtf8();
  var outPut = output.toNativeUtf8();

  cv temp = _nativLib.lookup<NativeFunction<cvFunc>>("printInOut").asFunction();

  temp(inputP, outPut);

  calloc.free(inputP);
  calloc.free(outPut);
}

void pageDetect(String input, String output) {
  var inputP = input.toNativeUtf8();
  var outPut = output.toNativeUtf8();

  cv temp = _nativLib.lookup<NativeFunction<cvFunc>>("pageDetect").asFunction();

  print("after lookup");
  temp(inputP, outPut);

  print("after function");

  calloc.free(inputP);
  calloc.free(outPut);
}
