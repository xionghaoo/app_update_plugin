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

  double _downloadProgress;

  downloadApk(String url, String versionName, String content, bool isForce) {
    _methodChannel.invokeMethod("downloadApk", {
      "url": url,
      "isForce": isForce
    });
  }

  navigateToAppStore() {
    _methodChannel.invokeMethod("navigateToAppStore");
  }

  _downloadProgressWidget() {
    return Center(
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: _downloadProgress / 100.0,
              ),
            ),
            Center(
              child: Text("${_downloadProgress.toInt()}%"),
            )
          ],
        ),
      ),
    );
  }

  showUpdateDialog({
    @required BuildContext context,
    @required String updateUrl,
    @required String appVersion,
    @required String appContent,
    bool isForce = false
  }) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)
                  ),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text("有新的版本$appVersion", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      SizedBox(height: 10),
                      Text(appContent),
                      SizedBox(height: 10),
                      _downloadProgress != null
                          ? _downloadProgressWidget()
                          : SizedBox(),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text("取消", style: TextStyle(color: Color(0xFF666666))),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(width: 10),
                            FlatButton(
                              child: Text("确定", style: TextStyle(color: Theme.of(context).primaryColor),),
                              onPressed: () {
                                updateStream.listen((progress) {
                                  setState(() {
                                    _downloadProgress = progress.toDouble();
                                  });
                                });
                                downloadApk(updateUrl, appVersion, appContent, isForce);
                              },
                            )
                          ]
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("有新的版本$appVersion"),
              content: Text(appContent),
              actions: <Widget>[
                FlatButton(
                  child: Text("取消"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("更新"),
                  onPressed: () {
                    navigateToAppStore();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    }
  }

}

