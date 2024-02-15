import 'package:flutter/material.dart';
import 'package:sheet_webview_plugin/src/message_channel.dart';


const _channel = ClientMessageChannel();

bool runWebViewTitleBarWidget(
  List<String> args, {
  WidgetBuilder? builder,
  Color? backgroundColor,
}) {
  if (args.isEmpty || args[0] != 'web_view_title_bar') {
    return false;
  }
  final webViewId = int.tryParse(args[1]);
  if (webViewId == null) {
    return false;
  }
  final titleBarTopPadding = int.tryParse(args.length > 2 ? args[2] : '0') ?? 0;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(_TitleBarApp(
    webViewId: webViewId,
    titleBarTopPadding: titleBarTopPadding,
    backgroundColor: backgroundColor,
    builder: builder ?? _defaultTitleBar,
  ));
  return true;
}




class _TitleBarApp extends StatefulWidget {
  const _TitleBarApp({
    Key? key,
    required this.webViewId,
    required this.titleBarTopPadding,
    required this.builder,
    this.backgroundColor,
  }) : super(key: key);

  final int webViewId;

  final int titleBarTopPadding;

  final WidgetBuilder builder;

  final Color? backgroundColor;

  @override
  State<_TitleBarApp> createState() => _TitleBarAppState();
}

class _TitleBarAppState extends State<_TitleBarApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color:
            widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(top: widget.titleBarTopPadding.toDouble()),
          child: Builder(builder: widget.builder)
        ),
      ),
    );
  }
}

Widget _defaultTitleBar(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 25,
          iconSize: 25,
          onPressed: () async {
            await _channel.invokeMethod("onClosePressed");
          },
          icon: const Icon(Icons.close),
        ),
        const SizedBox(
          width: 20,
        )
    ],
  );
}
