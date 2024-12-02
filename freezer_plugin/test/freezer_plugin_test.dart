import 'package:flutter_test/flutter_test.dart';
import 'package:freezer_plugin/freezer_plugin.dart';
import 'package:freezer_plugin/freezer_plugin_platform_interface.dart';
import 'package:freezer_plugin/freezer_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFreezerPluginPlatform
    with MockPlatformInterfaceMixin
    implements FreezerPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FreezerPluginPlatform initialPlatform = FreezerPluginPlatform.instance;

  test('$MethodChannelFreezerPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFreezerPlugin>());
  });

  test('getPlatformVersion', () async {
    FreezerPlugin freezerPlugin = FreezerPlugin();
    MockFreezerPluginPlatform fakePlatform = MockFreezerPluginPlatform();
    FreezerPluginPlatform.instance = fakePlatform;

    expect(await freezerPlugin.getPlatformVersion(), '42');
  });
}
