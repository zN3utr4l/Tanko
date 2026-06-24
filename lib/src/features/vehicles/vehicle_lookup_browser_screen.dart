import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const vehicleLookupMobileUserAgent =
    'Mozilla/5.0 (Linux; Android 14; Mobile; Carburo) '
    'AppleWebKit/537.36 (KHTML, like Gecko) '
    'Chrome/126.0.0.0 Mobile Safari/537.36';

const vehicleLookupViewportScript = '''
(function() {
  var meta = document.querySelector('meta[name="viewport"]');
  if (!meta) {
    meta = document.createElement('meta');
    meta.name = 'viewport';
    document.head.appendChild(meta);
  }
  meta.setAttribute(
    'content',
    'width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes'
  );
})();
''';

class VehicleLookupBrowserScreen extends StatefulWidget {
  const VehicleLookupBrowserScreen({
    super.key,
    required this.title,
    required this.uri,
  });

  final String title;
  final Uri uri;

  @override
  State<VehicleLookupBrowserScreen> createState() =>
      _VehicleLookupBrowserScreenState();
}

class _VehicleLookupBrowserScreenState
    extends State<VehicleLookupBrowserScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(vehicleLookupMobileUserAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            _controller.runJavaScript(vehicleLookupViewportScript);
          },
        ),
      )
      ..loadRequest(widget.uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
