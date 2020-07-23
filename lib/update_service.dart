import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateService {

  static UpdateService _instance;

  factory UpdateService() {
    if (_instance == null) {
      MethodChannel methodChannel = MethodChannel("com.pgy/update");
      final eventChannel = EventChannel("com.pgy/update_stream");
      _instance = UpdateService._private(methodChannel, eventChannel);
    }
    return _instance;
  }

  UpdateService._private(this._methodChannel, this._eventChannel);

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;

  Stream<int> _updateStream;

  Stream<int> get updateStream {
    if (_updateStream == null) {
      _updateStream = _eventChannel.receiveBroadcastStream().map((dynamic data) => data);
    }
    return _updateStream;
  }

  double get downloadProgress => _downloadProgress;
  double _downloadProgress;

  addProgressListener(StateSetter setStateOuter) {
    updateStream.listen((progress) {
      setStateOuter(() {
        _downloadProgress = progress.toDouble();
      });
    });
  }

  downloadApk(String url, String versionName, String content, bool isForce, String appName) {
    _methodChannel.invokeMethod("downloadApk", {
      "url": url,
      "isForce": isForce,
      "appName": appName
    });
  }

  installApk() {
    _methodChannel.invokeMethod("installApk");
  }

  navigateToAppStore(String appId) {
    _methodChannel.invokeMethod("navigateToAppStore", {
      "appId": appId
    });
  }
}

