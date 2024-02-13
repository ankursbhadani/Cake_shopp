import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivecyPolicy extends StatelessWidget {
  const PrivecyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    return Scaffold(
      appBar: AppBar(
        title: Text('Privecy Policy'),
        backgroundColor: Colors.lightBlueAccent.shade100,
      ),
      body: WebViewWidget(
          controller: webViewController
            ..loadRequest(Uri.parse(
                "https://www.freeprivacypolicy.com/live/55be32b2-4916-4afe-8e32-aaadbbf9fdcc"))),
    );
  }
}
