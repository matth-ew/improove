import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  const WebViewScreen({
    Key? key,
    this.url = "https://improove.fit/",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              navigationDelegate: (NavigationRequest request) {
                if (request.url.contains("mailto:")) {
                  launch(request.url);
                  return NavigationDecision.prevent;
                } else if (request.url.contains("tel:")) {
                  launch(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: url,
            ),
            Positioned(
              top: 55,
              right: 15,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  primary: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
