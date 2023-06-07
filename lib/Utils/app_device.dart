import 'dart:io';
import 'package:device_info/device_info.dart';

class AppDevice {
  AppDevice._();
  static Future<String> getDeviceId() async {
    DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
    String _deviceId;
    if (Platform.isAndroid)
      _deviceId = (await _deviceInfo.androidInfo).androidId;
    else
      _deviceId = (await _deviceInfo.iosInfo).identifierForVendor;
    return _deviceId;
  }
}
