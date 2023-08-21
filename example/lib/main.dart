// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:adcio_agent/adcio_agent.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            final isStartPage = await isAgnetStartPage;

            isStartPage ? Navigator.of(context).canPop() : agentGoback();
          },
        ),
        title: const Text('adcio_agent example app'),
      ),
      body: AdcioAgent(
        clientId: '30cb6fd0-17a5-4c56-b144-fef67de81bef',
        baseUrl: 'https://agent-dev.adcio.ai',
        onClickProduct: (String productId) {
          log('productId = $productId');

          // Navigation and routing
          final route = MaterialPageRoute(
            builder: (context) => DemoProductPage(
              productId: productId,
            ),
          );
          Navigator.of(context).push(route);
        },
      ),
    );
  }
}

class DemoProductPage extends StatelessWidget {
  const DemoProductPage({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product $productId'),
      ),
      body: Center(
        child: Text('Product $productId'),
      ),
    );
  }
}
