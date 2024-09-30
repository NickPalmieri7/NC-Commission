import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let callChannel = FlutterMethodChannel(name: "com.yourcompany.calls/call",
                                               binaryMessenger: controller.binaryMessenger)
        callChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "makeCall" {
                if let args = call.arguments as? [String: Any],
                   let phoneNumber = args["phoneNumber"] as? String {
                    if let url = URL(string: "tel://\(phoneNumber)"),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                        result("Calling \(phoneNumber)")
                    } else {
                        result(FlutterError(code: "UNAVAILABLE", message: "Phone number not available.", details: nil))
                    }
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing phone number.", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
