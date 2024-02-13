import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    return Scaffold(
      appBar: AppBar(
        title: Text('AboutUs'),
        backgroundColor: Colors.lightBlueAccent.shade100,
      ),
      body: WebViewWidget(
          controller: webViewController
            ..loadRequest(Uri.parse(
                "https://www.fnp.com/info/about-us"))),
    );
  }
}
