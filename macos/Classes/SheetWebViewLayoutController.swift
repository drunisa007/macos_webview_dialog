//
//  SheetWebViewLayoutController.swift
//  sheet_webview_plugin
//
//  Created by Drunisa on 2/14/24.
//

import Cocoa
import FlutterMacOS
import WebKit

class SheetWebViewLayoutController: NSViewController {
    private let methodChannel: FlutterMethodChannel
    private let titleBarHeight: Int
    private let titleBarTopPadding: Int
    private var defaultUserAgent: String?
  
   private lazy var titleBarController: FlutterViewController = {
        let project = FlutterDartProject()
        project.dartEntrypointArguments = ["web_view_title_bar", "1", "\(titleBarTopPadding)"]
        return FlutterViewController(project: project)
    }()
    
    private lazy var webView: WKWebView = {
        WKWebView()
    }()
    
    
    public init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        self.titleBarHeight = 50
        self.titleBarTopPadding = 0
        super.init(nibName: "SheetWebViewLayoutController", bundle: Bundle(for: SheetWebViewLayoutController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        addChild(titleBarController)
        titleBarController.view.translatesAutoresizingMaskIntoConstraints = false
        SheetMessagePlugin.register(with: titleBarController.registrar(forPlugin: "SheetWebviewPlugin"))

        let flutterView = titleBarController.view
        
        flutterView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(flutterView)
        

        
        let constraints = [
            flutterView.topAnchor.constraint(equalTo: view.topAnchor),
            flutterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flutterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            flutterView.heightAnchor.constraint(equalToConstant: CGFloat(titleBarHeight + titleBarTopPadding)),
        ]
        

        
        NSLayoutConstraint.activate(constraints)

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: flutterView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        
    }
    
    func setApplicationNameForUserAgent(applicationName: String) {
        webView.customUserAgent = (defaultUserAgent ?? "") + applicationName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.configuration.preferences.minimumFontSize = 12
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webView.configuration.allowsAirPlayForMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .video
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        defaultUserAgent = webView.value(forKey: "userAgent") as? String
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "URL"{
            if let key = change?[NSKeyValueChangeKey.newKey] {
                let urlString = "\(key)"
                methodChannel.invokeMethod("onUrlRequested", arguments: [
                    "url": urlString,
                ] as [String: Any])
            }
        }
    }
    
    func load(url: URL) {
        webView.load(URLRequest(url: url))
    }
    func destroy() {
        webView.stopLoading(self)
        webView.removeFromSuperview()
    }
    
}

extension SheetWebViewLayoutController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        guard ["http", "https", "file"].contains(url.scheme?.lowercased() ?? "") else {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
}
