package your.package.name

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourcompany.calls/call"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "makeCall") {
                val phoneNumber: String? = call.argument("phoneNumber")
                phoneNumber?.let {
                    val intent = Intent(Intent.ACTION_DIAL)
                    intent.data = Uri.parse("tel:$it")
                    startActivity(intent)
                    result.success("Calling $it")
                } ?: result.error("UNAVAILABLE", "Phone number not available.", null)
            } else {
                result.notImplemented()
            }
        }
    }
}
