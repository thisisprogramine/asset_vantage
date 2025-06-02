
package com.assetVantagePune.support

import io.flutter.embedding.android.FlutterFragmentActivity

import android.os.Bundle
import android.os.Environment
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.assetVantagePune.support/save_file"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveFileToLocal") {
                val bytes = call.argument<ByteArray>("bytes")
                val fileName = call.argument<String>("fileName")
                val extension = call.argument<String>("extension")

                if (bytes == null || fileName == null || extension == null) {
                    result.error("INVALID_ARGUMENTS", "One or more arguments are null", null)
                    return@setMethodCallHandler
                }

                val savedPath = saveFileToLocalStorage(applicationContext, bytes, fileName, extension)
                if (savedPath != null) {
                    result.success(savedPath)
                } else {
                    result.error("SAVE_FAILED", "Failed to save file", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun saveFileToLocalStorage(
        context: Context,
        bytes: ByteArray,
        fileName: String,
        extension: String
    ): String? {
        val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        val file = File(downloadsDir, "$fileName")
        return try {
            val fos = FileOutputStream(file)
            fos.write(bytes)
            fos.flush()
            fos.close()
            file.absolutePath
        } catch (e: IOException) {
            e.printStackTrace()
            null
        }
    }
}