package com.diepthanhduy.assistant_pak

import android.content.Intent
import android.net.Uri
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private var sharedPdfChannel: MethodChannel? = null
    private var initialPdfPath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        sharedPdfChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARED_PDF_CHANNEL).apply {
                setMethodCallHandler { call, result ->
                    when (call.method) {
                        "takeInitialPdf" -> {
                            result.success(initialPdfPath)
                            initialPdfPath = null
                        }
                        else -> result.notImplemented()
                    }
                }
            }
        initialPdfPath = consumeSharedPdf(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val path = consumeSharedPdf(intent) ?: return
        sharedPdfChannel?.invokeMethod("onPdfShared", path)
    }

    /**
     * Copies a PDF received via VIEW / SEND into the cache and returns its path.
     * The intent is cleared so a recreated activity does not import it twice.
     * Never logs the URI or file name (patient data).
     */
    private fun consumeSharedPdf(intent: Intent?): String? {
        val uri = when (intent?.action) {
            Intent.ACTION_VIEW -> intent.data
            Intent.ACTION_SEND -> streamExtra(intent)
            else -> null
        } ?: return null
        intent?.action = null
        return try {
            val directory = File(cacheDir, "shared_pdf").apply {
                deleteRecursively()
                mkdirs()
            }
            val target = File(directory, "shared_${System.currentTimeMillis()}.pdf")
            val input = contentResolver.openInputStream(uri) ?: return null
            input.use { source -> target.outputStream().use { source.copyTo(it) } }
            target.absolutePath
        } catch (e: Exception) {
            null
        }
    }

    private fun streamExtra(intent: Intent): Uri? =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(Intent.EXTRA_STREAM)
        }

    private companion object {
        const val SHARED_PDF_CHANNEL = "com.diepthanhduy.assistant_pak/shared_pdf"
    }
}
