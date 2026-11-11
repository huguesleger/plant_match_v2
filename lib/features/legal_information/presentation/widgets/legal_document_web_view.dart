import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_gate.dart';

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
        AppLoaderGate(
          isLoading: isLoading,
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
