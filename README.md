# adcio_agent

[![pub package](https://img.shields.io/pub/v/adcio_agent.svg)](https://pub.dev/packages/adcio_agent)

A Flutter plugin that provides a ADCIO Agent Widget service. This is an LLM (GPT)-based chatbot that recommends customized products through conversation.

To learn more about ADCIO, please visit the [ADCIO website](https://www.adcio.ai/)

## Getting Started
To get started with ADCIO account, please register [ADCIO account](https://app.adcio.ai/en/)

## Usage

> **_NOTE:_**  All adcio packages require the [adcio_core](https://pub.dev/packages/adcio_core) package as a dependency and make use of `initializeApp()` for setup.

There is a simple use example:

```dart
import 'package:adcio_placement/adcio_placement.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      ...
      title: const Text('adcio_agent example app'),
    ),
    body: AdcioAgent(
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
```
To learn more about usage of plugin, please visit the [adcio_agent Usage documentation.](https://docs.adcio.ai/en/sdk/agent/flutter)

## Issues and feedback
If the plugin has issues, bugs, feedback, Please contact <dev@corca.ai>.