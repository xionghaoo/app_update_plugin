import 'dart:async';

import 'package:flutter/services.dart';

class Appupdateplugin {
  static const MethodChannel _channel =
      const MethodChannel('appupdateplugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
