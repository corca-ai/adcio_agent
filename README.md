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
