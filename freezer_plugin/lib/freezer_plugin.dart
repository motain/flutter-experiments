
import 'freezer_plugin_platform_interface.dart';

class FreezerPlugin {
  Future<String?> getPlatformVersion() {
    return FreezerPluginPlatform.instance.getPlatformVersion();
  }
}
