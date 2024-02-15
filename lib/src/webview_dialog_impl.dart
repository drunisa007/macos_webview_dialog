import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sheet_webview_plugin/src/webview_dialog.dart';

class WebViewDialogImpl extends WebViewDialog {
  final MethodChannel methodChannel;
  OnUrlRequestCallback? _onUrlRequestCallback;


  WebViewDialogImpl(this.methodChannel);

  @override
  Future<void> close() async {
     await methodChannel.invokeMethod("close");
  }

  @override
  Future<void> launch(String url) async {
    await methodChannel.invokeMethod("launch", {"url": url});
  }

  @override
  bool notifyUrlChanged(String url) {
   if (_onUrlRequestCallback != null) {
      return _onUrlRequestCallback!(url);
    } else {
      return true;
    }
  }

  @override
  Future<void> setApplicationNameForUserAgent(String applicationName) async {
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      return;
    }
    await methodChannel.invokeMethod("setApplicationNameForUserAgent", {
      "applicationName": applicationName,
    });
  }

  @override
  void setOnUrlRequestCallback(OnUrlRequestCallback? callback) {
    _onUrlRequestCallback = callback;
  }
}
