import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'page_detect_plugin_method_channel.dart';

abstract class PageDetectPluginPlatform extends PlatformInterface {
  /// Constructs a PageDetectPluginPlatform.
  PageDetectPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static PageDetectPluginPlatform _instance = MethodChannelPageDetectPlugin();

  /// The default instance of [PageDetectPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelPageDetectPlugin].
  static PageDetectPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PageDetectPluginPlatform] when
  /// they register themselves.
  static set instance(PageDetectPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
