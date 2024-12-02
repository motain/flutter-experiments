import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'freezer_plugin_platform_interface.dart';

/// An implementation of [FreezerPluginPlatform] that uses method channels.
class MethodChannelFreezerPlugin extends FreezerPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('freezer_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
