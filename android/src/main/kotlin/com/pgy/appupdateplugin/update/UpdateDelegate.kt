package com.pgy.appupdateplugin.update

import android.Manifest
import android.app.Activity
import android.app.AlertDialog
import android.content.ComponentName
import android.content.ServiceConnection
import android.os.IBinder
import android.view.LayoutInflater
import android.widget.ProgressBar
import android.widget.TextView
import com.pgy.appupdateplugin.R

class UpdateDelegate(
    private val context: Activity,
    private val progressCallback: (Int) -> Unit
) : DownloadService.DownloadCallback {

    private lateinit var mService: DownloadService
    private var mBound: Boolean = false

    private val connection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            val binder = service as DownloadService.DownloadBinder
            mService = binder.getService()
            if (mService.isForceUpdate == true) {
                mService.setDownloadCallback(this@UpdateDelegate)
            }
            mService.downloadApk()
            mBound = true
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            mBound = false
        }
    }

    private var tvDownload: TextView? = null
    private var progressBar: ProgressBar? = null
    private var btnConfirm: TextView? = null
    private var urlReinstall: String? = null

    fun startDownloadService(url: String, isForce: Boolean?) {
        DownloadService.startService(context, connection, url, isForce)
    }

    fun stopService() {
        if (mBound) {
            DownloadService.stopService(context, connection)
        }
    }

    override fun onPrepare() {
        progressCallback(0)
    }

    override fun onProgress(progress: Int) {
        context.runOnUiThread {
            progressCallback(progress)
            tvDownload?.text = "下载进度${progress}%"
            progressBar?.progress = progress
        }
    }

    override fun onComplete() {
        context.runOnUiThread {
            progressCallback(100)
            tvDownload?.text = "下载完成"
            btnConfirm?.text = "点击安装"
            btnConfirm?.setOnClickListener {
                if (mService.reInstallApk != null) {
                    mService.installApk(mService.reInstallApk!!)
                }
            }
        }
        DownloadService.stopService(context, connection)
    }

    override fun onError(error: String) {
        context.runOnUiThread {
            progressCallback(-1)
            tvDownload?.text = "下载失败，请重新下载"
            btnConfirm?.text = "重新下载"
            btnConfirm?.setOnClickListener {
//                downloadDialog?.dismiss()
                DownloadService.startService(context, connection, urlReinstall, mService.isForceUpdate)
            }
        }
        DownloadService.stopService(context, connection)
    }
}