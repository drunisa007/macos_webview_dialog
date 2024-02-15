# Sheet WebView Plugin

Show a webview sheet on your flutter desktop application.

|          |       |     |
| -------- | ------- | ---- |
| macOS    | ✅     |  WKWebview |

## Getting Started

1. modify your `main` method.
   ```dart
   import 'package:sheet_webview_plugin/sheet_webview.dart';
   
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     // Add this your main method.
     // used to show a webview title bar.
     if (runWebViewTitleBarWidget(args)) {
       return;
     }
   
     runApp(MyApp());
   }
   
   ```

2. launch WebView Dialog

   ```dart
    SheetWebView sheetWebView = SheetWebView();
          WebViewDialog? webViewDialog = await sheetWebView.init();
          if (webViewDialog != null) {
            webViewDialog
              ..setOnUrlRequestCallback((url) {
                debugPrint(url);
                return true;
              })
              ..setApplicationNameForUserAgent("SheetWebViewExample/1.0.0")
              ..launch("www.example.com");
          }
   ```

## License

see [LICENSE](./LICENSE)
