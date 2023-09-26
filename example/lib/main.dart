// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:adcio_agent/adcio_agent.dart';
import 'package:adcio_core/adcio_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// this is important to call `AdcioCore.initializeApp(clientId: 'ADCIO_STORE_ID')` function.
  await AdcioCore.initializeApp(
    clientId: 'f8f2e298-c168-4412-b82d-98fc5b4a114a',
  );

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
            final isStartPage = await isAgentStartPage;

            isStartPage ? Navigator.of(context).canPop() : agentGoback();
          },
        ),
        title: const Text('adcio_agent example app'),
      ),
      body: AdcioAgent(
        showAppbar: true,
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
