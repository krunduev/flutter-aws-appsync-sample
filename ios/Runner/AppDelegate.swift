import UIKit
import Flutter
import AWSCore
import AWSAppSync

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        AppSyncPlugin.register(with: registrar(forPlugin: "AppSyncPlugin"))
        // [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
}
