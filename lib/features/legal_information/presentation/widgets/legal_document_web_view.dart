import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:plant_match_v2/core/widgets/dots_loader/dots_loader_page.dart';

class LegalDocumentWebView extends StatelessWidget {
  const LegalDocumentWebView({
    super.key,
    required this.controller,
    required this.isLoading,
  });

  final WebViewController controller;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (isLoading) const Positioned.fill(child: DotsLoaderPage()),
      ],
    );
  }
}
