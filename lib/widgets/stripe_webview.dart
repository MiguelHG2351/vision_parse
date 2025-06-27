import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeWebView extends StatefulWidget {
  final String url;
  final VoidCallback onClose;

  const StripeWebView({super.key, required this.url, required this.onClose});

  @override
  State<StripeWebView> createState() => _StripeWebViewState();
}

class _StripeWebViewState extends State<StripeWebView> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializa el controller con configuraciones básicas:
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => debugPrint('Cargando $url'),
          onPageFinished: (url) => debugPrint('Terminado $url'),
          onNavigationRequest: (request) {
            // Aquí puedes interceptar navegación si quieres
            if (request.url.startsWith('https://example.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago Premium'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onClose,
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
