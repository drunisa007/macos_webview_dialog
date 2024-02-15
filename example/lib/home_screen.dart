import 'package:flutter/material.dart';
import 'package:sheet_webview_plugin/sheet_webview.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: TextButton(
        onPressed: () async {
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
        },
        child: const Text('Open'),
      )),
    );
  }
}
