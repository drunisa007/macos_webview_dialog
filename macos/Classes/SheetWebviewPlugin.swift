import Cocoa
import FlutterMacOS

public class SheetWebviewPlugin: NSObject, FlutterPlugin {
    private let methodChannel: FlutterMethodChannel
    private var webview: SheetWebViewWindowController?
    
    public init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sheet_webview_plugin", binaryMessenger: registrar.messenger)
        let instance = SheetWebviewPlugin(methodChannel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        SheetMessagePlugin.register(with: registrar)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print(call.method)
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        case "create":
            let controller = SheetWebViewWindowController(
                methodChannel: methodChannel
            )
            controller.webviewPlugin = self
            webview = controller
            
            if  let mainWindow = NSApplication.shared.windows.first{
                if let showView = controller.window{
                    mainWindow.beginSheet(showView)
                }
            }
            result(1)
            break
            
        case "setApplicationNameForUserAgent":
          guard let argument = call.arguments as? [String: Any?] else {
            result(FlutterError(code: "0", message: "arg is not map", details: nil))
            return
          }
         
          guard let applicationName = argument["applicationName"] as? String else {
            result(FlutterError(code: "0", message: "param applicationName not found", details: nil))
            return
          }
          webview?.webViewController.setApplicationNameForUserAgent(applicationName: applicationName)
          result(nil)
          break
            
        case "launch":
            
            guard let argument = call.arguments as? [String: Any?] else {
                result(FlutterError(code: "0", message: "arg is not map", details: nil))
                return
            }
            
            guard let url = argument["url"] as? String else {
                result(FlutterError(code: "0", message: "param url not found", details: nil))
                return
            }
            
            guard let parsedUrl = URL(string: url) else {
                result(FlutterError(code: "0", message: "failed to parse \(url)", details: nil))
                return
            }
            
            webview?.webViewController.load(url: parsedUrl)
            result("success")
            break
            
        case "close":
            webview?.close()
            result("success")
            break;
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
