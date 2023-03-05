import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_detect_plugin/page_detect_plugin_method_channel.dart';

void main() {
  MethodChannelPageDetectPlugin platform = MethodChannelPageDetectPlugin();
  const MethodChannel channel = MethodChannel('page_detect_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
