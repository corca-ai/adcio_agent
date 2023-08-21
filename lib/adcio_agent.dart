import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Constructs a [AdcioAgent].
///
/// example code:
/// ```dart
/// AdcioAgent(
///   clientId: '30cb6fd0-17a5-4c56-b144-fef67de81bef',
///   onClickProduct: (String productId) { ... },
/// )
/// ```
class AdcioAgent extends StatefulWidget {
  const AdcioAgent({
    super.key,
    required this.clientId,
    required this.onClickProduct,
    this.baseUrl = 'https://agent.adcio.ai',
    this.onNavigationRequest,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
    this.onUrlChange,
  });

  /// This is the Client ID (Client Unique Number) written in the ADCIO Admin Console.
  ///
  /// Location: ADCIO admin console → account → client info → Client Unique Number
  final String clientId;

  /// When clicking on a product recommended by LLM(GPT), the product ID value is returned to the client app.
  ///
  /// Typically, post-processing tasks like page routing are performed.
  ///
  /// ```dart
  /// AdcioAgent(
  ///   ...
  ///   onClickProduct: (String productId) {
  ///     Navigator.pushNamed(context, '/product/$productId');
  ///   }
  /// ),
  /// ```
  final void Function(String productId) onClickProduct;

  /// This is the ADCIO Agent URL.
  final String baseUrl;

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

    return '${widget.baseUrl}/$clientId/start/?platform=$platform';
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
    return WillPopScope(
      onWillPop: () => _controller.canGoBack().then(
        (canGoBack) {
          if (canGoBack) {
            _controller.goBack();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
      ),
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
