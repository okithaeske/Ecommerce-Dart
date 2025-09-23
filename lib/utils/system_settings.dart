import 'dart:io' show Platform;
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openDisplaySettings(BuildContext context) async {
  try {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'android.settings.DISPLAY_SETTINGS',
      );
      await intent.launch();
      return;
    }
    if (Platform.isIOS) {
      // iOS does not allow deep-linking to Display settings; open app settings instead
      final uri = Uri.parse('app-settings:');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
    }
  } catch (_) {}
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open system settings on this device')),
    );
  }
}

