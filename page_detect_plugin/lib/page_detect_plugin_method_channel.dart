import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'page_detect_plugin_platform_interface.dart';

/// An implementation of [PageDetectPluginPlatform] that uses method channels.
class MethodChannelPageDetectPlugin extends PageDetectPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('page_detect_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
