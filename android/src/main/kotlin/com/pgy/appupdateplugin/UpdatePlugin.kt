package com.pgy.appupdateplugin

import android.app.Activity
import android.util.Log
import com.pgy.appupdateplugin.update.UpdateDelegate
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UpdatePlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, EventChannel.StreamHandler {

    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    private var updateDelegate: UpdateDelegate? = null

    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("UpdatePlugin", "onAttachedToEngine")
        pluginBinding = binding
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("UpdatePlugin", "onDetachedFromEngine")

        pluginBinding = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "downloadApk") {
            val url = call.argument<String>("url")
            val isForce = call.argument<Boolean>("isForce")
            if (url != null) {
//                updateDelegate?.downloadApk(url, versionName, content, isForce) {
//                    // on cancel
//                }
                updateDelegate?.startDownloadService(url, isForce)
            }
        }
        if (call.method == "installApk") {
            updateDelegate?.installApk()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onDetachedFromActivity() {
        Log.d("UpdatePlugin", "onDetachedFromActivity")

        updateDelegate?.stopService()
        updateDelegate = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d("UpdatePlugin", "onAttachedToActivity")
        val channel = MethodChannel(pluginBinding?.binaryMessenger, "com.pgy/update")
        channel.setMethodCallHandler(this)

        eventChannel = EventChannel(pluginBinding?.binaryMessenger, "com.pgy/update_stream")
        eventChannel?.setStreamHandler(this)

        updateDelegate = UpdateDelegate(binding.activity) {
            eventSink?.success(it)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}