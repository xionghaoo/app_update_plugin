//
//  UpdatePlugin.swift
//  appupdateplugin
//
//  Created by xionghao on 2020/5/20.
//

import Flutter
import UIKit

public class SwiftUpdatePlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.pgy/update", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(SwiftUpdatePlugin(), channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "navigateToAppStore":
            if let scheme = URL(string: "itms-apps://itunes.apple.com/app/1509974002") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(scheme, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(scheme)
                }
            }
            result(nil)
        default:
            result(nil)
        }
    }
    
}
