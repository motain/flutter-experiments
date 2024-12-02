import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'freezer_plugin_method_channel.dart';

abstract class FreezerPluginPlatform extends PlatformInterface {
  /// Constructs a FreezerPluginPlatform.
  FreezerPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FreezerPluginPlatform _instance = MethodChannelFreezerPlugin();

  /// The default instance of [FreezerPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFreezerPlugin].
  static FreezerPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FreezerPluginPlatform] when
  /// they register themselves.
  static set instance(FreezerPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
