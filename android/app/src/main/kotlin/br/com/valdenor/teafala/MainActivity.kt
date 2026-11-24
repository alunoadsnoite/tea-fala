package br.com.valdenor.teafala

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "br.com.valdenor.teafala/print_board",
        ).setMethodCallHandler { call, result ->
            if (call.method != "createPdf") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            val title = call.argument<String>("title")
            val labels = call.argument<List<String>>("labels")
            if (title == null || labels == null || labels.size != 7) {
                result.error("INVALID_BOARD", "Expected a title and seven labels.", null)
                return@setMethodCallHandler
            }
            try {
                result.success(CommunicationBoardPdf.create(title, labels))
            } catch (_: Exception) {
                result.error("PDF_ERROR", "Could not create the communication board.", null)
            }
        }
    }
}
