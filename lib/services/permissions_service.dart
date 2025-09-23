
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static Future<bool> ensureLocation() async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isGranted) return true;
    final res = await Permission.locationWhenInUse.request();
    return res.isGranted;
  }

  static Future<bool> ensureCamera() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    final res = await Permission.camera.request();
    return res.isGranted;
  }

  static Future<bool> ensureMicrophone() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;
    final res = await Permission.microphone.request();
    return res.isGranted;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }
}

