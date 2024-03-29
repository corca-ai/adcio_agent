import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

final _controller = WebViewController.fromPlatformCreationParams(
  const PlatformWebViewControllerCreationParams(),
);

const _startPage = 'start/';

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
    this.showAppbar = false,
  });

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

  final bool showAppbar;

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
  String get _agentUrl {
    final clientId = widget.clientId;
    final platform = Platform.operatingSystem.toLowerCase();
    final showAppbar = widget.showAppbar;

    final url =
        '${widget.baseUrl}/$clientId/$_startPage?platform=$platform&show_appbar=$showAppbar';
    debugPrint(url);
    return url;
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
  void dispose() {
    _controller.removeJavaScriptChannel('ProductRouter');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: agentGoback,
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}

Future<bool> get isAgentStartPage => _controller
    .currentUrl()
    .then((value) => value?.contains(_startPage) ?? false);

Future<bool> agentGoback() {
  return _controller.canGoBack().then(
    (canGoBack) {
      if (canGoBack) {
        _controller.goBack();
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    },
  );
}
