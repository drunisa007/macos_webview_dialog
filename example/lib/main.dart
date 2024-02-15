import 'package:flutter/material.dart';
import 'package:sheet_webview_plugin/sheet_webview.dart';
import 'package:sheet_webview_plugin_example/home_screen.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Sheet WebView Example",
      home: HomeScreen(),
    );
  }
}
