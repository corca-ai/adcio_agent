# adcio_agent

A Flutter plugin that provides a ADCIO Agent widget.


|             | Android        | iOS   |
|-------------|----------------|-------|
| **Support** | SDK 19+ or 20+ | 11.0+ |

</br>

## Usage

### Installation

Add `adcio_agent` as a [dependency in your pubspec.yaml file](https://pub.dev/packages/adcio_agent/install).

### Android

This plugin uses
[Platform Views](https://flutter.dev/docs/development/platform-integration/platform-views) to embed
the Android’s WebView within the Flutter app.

You should however make sure to set the correct `minSdkVersion` in `android/app/build.gradle` if it was previously lower than 19:

```groovy
android {
    defaultConfig {
        minSdkVersion 19
    }
}
```

### Sample Usage
You can now display a ADCIO Agent by:
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('adcio_agent example app'),
    ),
    body: AdcioAgent(
      clientId: '30cb6fd0-17a5-4c56-b144-fef67de81bef',
      flavor: Flavor.dev,
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
| property        | description                                                        | default    |
| --------------- | ------------------------------------------------------------------ |------------|
| clientId             | String                                         |required    |
| onClickProduct         | void Function(String productId) | required    |

</br>

## Preview Images

**Android:**

<p float="left">
  <img width="200" alt="image" src="https://github.com/corca-ai/adcio_agent/assets/51875059/013ab4d8-7f6c-4522-9d1d-8b0f415d69b4">
  <img width="200" alt="image" src="https://github.com/corca-ai/adcio_agent/assets/51875059/2b96aea1-6098-4e76-96e0-582570a5438b">
</p>

iOS:

<p float="left">
  <img width="200" alt="image" src="https://github.com/corca-ai/adcio_agent/assets/51875059/b80f1ccf-bede-462d-9bf8-b82d02029d5b">
  <img width="200" alt="image" src="https://github.com/corca-ai/adcio_agent/assets/51875059/5279bedf-b427-4fc7-94e7-d30f023b0048">
</p>
