import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
        child: WebView(
          initialUrl: 'https://improove.fit/terms',
        ),
      ),
    );
  }
}
