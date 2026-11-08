import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(color: AppColors.blueGreen),
          ),
      ],
    );
  }
}
