import 'package:flutter_test/flutter_test.dart';
import 'package:page_detect_plugin/page_detect_plugin.dart';
import 'package:page_detect_plugin/page_detect_plugin_platform_interface.dart';
import 'package:page_detect_plugin/page_detect_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPageDetectPluginPlatform
    with MockPlatformInterfaceMixin
    implements PageDetectPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PageDetectPluginPlatform initialPlatform = PageDetectPluginPlatform.instance;

  test('$MethodChannelPageDetectPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPageDetectPlugin>());
  });

  test('getPlatformVersion', () async {
    PageDetectPlugin pageDetectPlugin = PageDetectPlugin();
    MockPageDetectPluginPlatform fakePlatform = MockPageDetectPluginPlatform();
    PageDetectPluginPlatform.instance = fakePlatform;

    expect(await pageDetectPlugin.getPlatformVersion(), '42');
  });
}
