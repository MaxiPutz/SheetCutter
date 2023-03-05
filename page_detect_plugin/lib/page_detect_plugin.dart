import 'dart:isolate';
import 'dart:async';
import 'page_detect_plugin_platform_interface.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

/*
copy this line to the end of the running app cmake-
cat > linux/Cmakelists.tyt << EOF
#add this line at the very end of the install commands
install(FILES ${PROJECT_BINARY_DIR}/libs/libapi.so DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
EOF
*/

class PageDetectPlugin {
  Future<String?> getPlatformVersion() {
    return PageDetectPluginPlatform.instance.getPlatformVersion();
  }
}

final DynamicLibrary nativLib = DynamicLibrary.open("libapi.so");

typedef OpenCVFunc = Int Function(Pointer<Utf8> inPath, Pointer<Utf8> outPath);
typedef CvCornerFunc = Void Function(
    Pointer<Utf8> inPath,
    Pointer<Utf8> outPath,
    Int tlx,
    Int tly,
    Int trx,
    Int _try,
    Int blx,
    Int bly,
    Int brx,
    Int bry);
typedef Add_Func = Int Function(Int a, Int b);
typedef GetVersionFunc = Pointer<Utf8> Function();

typedef OpenCV = int Function(Pointer<Utf8> inPath, Pointer<Utf8> outPath);
typedef CvCorner = void Function(Pointer<Utf8> inPath, Pointer<Utf8> outPath,
    int tlx, int tly, int trx, int _try, int blx, int bly, int brx, int bry);

typedef Add = int Function(int a, int b);
typedef GetVersion = Pointer<Utf8> Function();

// GetVersion _getVersion =
//     nativLib.lookup<NativeFunction<GetVersionFunc>>("getVersion").asFunction();

OpenCV _pageDetect =
    nativLib.lookup<NativeFunction<OpenCVFunc>>("p1").asFunction();

OpenCV _pageDetect2 =
    nativLib.lookup<NativeFunction<OpenCVFunc>>("pageDetect").asFunction();

CvCorner _cvCorner =
    nativLib.lookup<NativeFunction<CvCornerFunc>>("cvCorner").asFunction();

class OpenCVClass {
  String inPath;
  String outPath;
  SendPort port;
  OpenCVClass(this.inPath, this.outPath, this.port);
}

Future<void> pageDetectIsolate(String inPath, String outPath) async {
  final Completer completer = Completer();
  ReceivePort port = ReceivePort();

  await Isolate.spawn<OpenCVClass>((args) {
    pageDetect(args.inPath, args.outPath);
    args.port.send("after isolate");
  }, OpenCVClass(inPath, outPath, port.sendPort));

  var msg = await port.first;
  print(msg);
  return completer.complete();
}

void pageDetect(String inPath, String outPath) {
  final iP = inPath.toNativeUtf8();
  final oP = outPath.toNativeUtf8();

  var ele = _pageDetect(iP, oP);

  print(ele);
  malloc.free(iP);
  malloc.free(oP);
}

void pageDetect2(String inPath, String outPath) {
  final iP = inPath.toNativeUtf8();
  final oP = outPath.toNativeUtf8();

  var ele = _pageDetect2(iP, oP);

  print(ele);
  malloc.free(iP);
  malloc.free(oP);
}

void cvCorner(String inPath, String outPath, int tlx, int tly, int trx,
    int _try, int blx, int bly, int brx, int bry) {
  final iP = inPath.toNativeUtf8();
  final oP = outPath.toNativeUtf8();

  _cvCorner(iP, oP, tlx, tly, trx, _try, blx, bly, brx, bry);

  malloc.free(iP);
  malloc.free(oP);
}
