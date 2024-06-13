import 'package:package_info_plus/package_info_plus.dart';

class BuildUtils {
  static Future<BuildDetails> getappBuild() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return BuildDetails(appName, packageName, version, buildNumber);
  }
}

class BuildDetails {
  String appName, packageName, version, buildNumber;
  BuildDetails(this.appName, this.packageName, this.version, this.buildNumber);

  static BuildDetails get empty => BuildDetails('', '', '', '');
}
