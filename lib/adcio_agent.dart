import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum Flavor { dev, prod }

class AdcioAgent extends StatefulWidget {
  const AdcioAgent({
    super.key,
    required this.clientId,
    this.flavor = Flavor.prod,
    required this.onClickProduct,
    this.onNavigationRequest,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
    this.onUrlChange,
  });

  final String clientId;
  final Flavor flavor;

  final void Function(String productId) onClickProduct;
  final FutureOr<NavigationDecision> Function(NavigationRequest request)?
      onNavigationRequest;
  final void Function(String url)? onPageStarted;
  final void Function(String url)? onPageFinished;
  final void Function(int progress)? onProgress;
  final void Function(WebResourceError error)? onWebResourceError;
  final void Function(UrlChange change)? onUrlChange;

  @override
  State<AdcioAgent> createState() => _AdcioAgentState();
}

class _AdcioAgentState extends State<AdcioAgent> {
  final _controller = WebViewController.fromPlatformCreationParams(
    const PlatformWebViewControllerCreationParams(),
  );

  String get _agentUrl {
    final clientId = widget.clientId;
    final platform = Platform.operatingSystem.toLowerCase();
    final baseUrl = (Flavor.dev == widget.flavor)
        ? 'https://agent-dev.adcio.ai'
        : 'https://agent.adcio.ai';

    return '$baseUrl/$clientId/start/?platform=$platform';
  }

  @override
  void initState() {
    super.initState();
    _controller
      ..loadRequest(Uri.parse(_agentUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'ProductRouter',
        onMessageReceived: (message) {
          widget.onClickProduct(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: widget.onNavigationRequest,
          onPageStarted: widget.onPageStarted,
          onPageFinished: widget.onPageFinished,
          onProgress: widget.onProgress,
          onWebResourceError: widget.onWebResourceError,
          onUrlChange: widget.onUrlChange,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}
