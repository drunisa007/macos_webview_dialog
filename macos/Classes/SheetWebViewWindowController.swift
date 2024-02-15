//
//  SheetWebViewWindowController.swift
//  sheet_webview_plugin
//
//  Created by Drunisa on 2/14/24.
//

import Cocoa
import FlutterMacOS
import WebKit

class SheetWebViewWindowController: NSWindowController {
    private let methodChannel: FlutterMethodChannel
    public weak var webviewPlugin: SheetWebviewPlugin?

    init(methodChannel: FlutterMethodChannel) {
      self.methodChannel = methodChannel
      super.init(window: nil)

      let newWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 700, height: 900), styleMask: [.titled, .closable, .fullSizeContentView], backing: .buffered, defer: false)
      newWindow.delegate = self
      newWindow.title = "Sheet Web View"
      newWindow.titlebarAppearsTransparent = true

      let contentViewController = SheetWebViewLayoutController(
        methodChannel: methodChannel)
      newWindow.contentViewController = contentViewController
      newWindow.setContentSize(NSSize(width: 700, height: 800))
      newWindow.center()


      window = newWindow
    }
    
    func destroy() {
      webViewController.destroy()
      webviewPlugin = nil
      window?.delegate = nil
      window = nil
    }
    
    func setAppearance(brightness: Int) {
      switch brightness {
      case 0:
        if #available(macOS 10.14, *) {
          window?.appearance = NSAppearance(named: .darkAqua)
        } else {
          // Fallback on earlier versions
        }
        break
      case 1:
        window?.appearance = NSAppearance(named: .aqua)
        break
      default:
        window?.appearance = nil
        break
      }
    }


    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    public var webViewController: SheetWebViewLayoutController {
      window?.contentViewController as! SheetWebViewLayoutController
    }
}

extension SheetWebViewWindowController: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
      webViewController.destroy()
  }
}
