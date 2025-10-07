import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static Future<bool> ensureLocation() async {
    return _requestPermission(Permission.locationWhenInUse);
  }

  static Future<bool> ensureCamera() async {
    return _requestPermission(Permission.camera);
  }

  static Future<bool> ensureMicrophone() async {
    return _requestPermission(Permission.microphone);
  }

  static Future<bool> ensureSpeechRecognition() async {
    if (!Platform.isIOS) {
      return true;
    }
    return _requestPermission(Permission.speech);
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  static Future<bool> _requestPermission(Permission permission) async {
    final initialStatus = await permission.status;
    if (_isGranted(initialStatus)) {
      return true;
    }
    final result = await permission.request();
    return _isGranted(result);
  }

  static bool _isGranted(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return true;
      default:
        return false;
    }
  }
}
