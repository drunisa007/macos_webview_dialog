typedef OnUrlRequestCallback = bool Function(String url);

abstract class WebViewDialog {
  Future<void> setApplicationNameForUserAgent(String applicationName);
  Future<void> close();
  void setOnUrlRequestCallback(OnUrlRequestCallback? callback);
  bool notifyUrlChanged(String url);
  Future<void> launch(String url);
}
