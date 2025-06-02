import UIKit
import Flutter
import NewRelic
import restart

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    NewRelic.start(withApplicationToken:"AA7efab293c6788d87e8185baae29acbb17c339b77-NRMA")
    GeneratedPluginRegistrant.register(with: self)
    RestartPlugin.generatedPluginRegistrantRegisterCallback = { [weak self] in
                GeneratedPluginRegistrant.register(with: self!)
            }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
