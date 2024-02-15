//
//  SheetMessagePlugin.swift
//  sheet_webview_plugin
//
//  Created by Drunisa on 2/14/24.
//


import FlutterMacOS
import Foundation

public class SheetMessagePlugin: NSObject, FlutterPlugin {
    private let methodChannel: FlutterMethodChannel

    public init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sheet_message/client_channel", binaryMessenger: registrar.messenger)
        let instance = SheetMessagePlugin(methodChannel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        ServerMessageChannel.shared.addClient(client: instance)
    }
   
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        ServerMessageChannel.shared.dispatchMethodCall(call: call, from: self)
        result(nil)
    }
    
    fileprivate func invokeMethod(_ call: FlutterMethodCall) {
        methodChannel.invokeMethod(call.method, arguments: call.arguments)
    }
}

class ServerMessageChannel {
    static let shared: ServerMessageChannel = ServerMessageChannel()
    private var clients: [SheetMessagePlugin] = []

    func addClient(client: SheetMessagePlugin) {
        clients.append(client)
    }
    
  
    func dispatchMethodCall(call: FlutterMethodCall, from clientFrom: SheetMessagePlugin) {
        if(call.method=="onClosePressed"){
            if clients.count>1 {
                for client in clients {
                    if client != clientFrom{
                        client.invokeMethod(call)
                        clients.removeSubrange(1..<clients.count)
                    }
                }
            }
        
        }
    }
}
