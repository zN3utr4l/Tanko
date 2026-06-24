import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
