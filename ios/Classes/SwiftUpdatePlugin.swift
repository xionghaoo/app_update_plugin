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
            if let arguments = call.arguments as? Dictionary<String, Any?>,
                let appId = arguments["appId"] as? String,
                let scheme = URL(string: "itms-apps://itunes.apple.com/app/\(appId)") {
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
