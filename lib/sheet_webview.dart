


import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sheet_webview_plugin/sheet_webview.dart';
import 'package:sheet_webview_plugin/src/message_channel.dart';
import 'package:sheet_webview_plugin/src/webview_dialog_impl.dart';

export 'src/webview_dialog.dart';
export 'src/title_bar.dart';


class SheetWebView {
  final methodChannel = const MethodChannel('sheet_webview_plugin');
  static const _otherIsolateMessageHandler = ClientMessageChannel();

  WebViewDialog? webView;


 Future<WebViewDialog?> init() async {
    await methodChannel.invokeMethod("create");
    methodChannel.setMethodCallHandler((call) {
      return _handleSheetWebViewPluginMethodCall(call);
    });
    _otherIsolateMessageHandler.setMessageHandler(
      (call) => _handleOtherIsolateMethodCall(call),
    );
   webView = WebViewDialogImpl(methodChannel);
   return webView;
  }


  _handleOtherIsolateMethodCall(MethodCall call) async {
    debugPrint("_handleOtherIsolateMethodCall ${call.method}");
    switch (call.method) {
      case "onClosePressed":
        await webView?.close();
        break;
      default:
        debugPrint("this is defalt ${call.method}");
    }
  }

  _handleSheetWebViewPluginMethodCall(MethodCall call) async {
    final methodChannelArgs = call.arguments as Map;
    debugPrint("handle Sheet Method ${call.method}");
    debugPrint('args is $methodChannelArgs');
    switch (call.method) {
      case "onUrlRequested":
        final url = methodChannelArgs['url'] as String;
        Uri uri = Uri.parse(url);
        final ret = webView?.notifyUrlChanged(uri.toString());
        return ret;
      default:
        debugPrint("this is defalt ${call.method}");
    }
  }


}
