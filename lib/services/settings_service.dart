import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const _kBatteryThemeEnabled = 'battery_theme_enabled';
  static const _kBatteryThemeThreshold = 'battery_theme_threshold';
  static const _kSensorsHudEnabled = 'sensors_hud_enabled';

  bool _batteryThemeEnabled = true;
  int _batteryThemeThreshold = 80; // percent
  bool _sensorsHudEnabled = false;

  bool get batteryThemeEnabled => _batteryThemeEnabled;
  int get batteryThemeThreshold => _batteryThemeThreshold;
  bool get sensorsHudEnabled => _sensorsHudEnabled;

  SettingsService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _batteryThemeEnabled = prefs.getBool(_kBatteryThemeEnabled) ?? true;
    _batteryThemeThreshold = prefs.getInt(_kBatteryThemeThreshold) ?? 80;
    _sensorsHudEnabled = prefs.getBool(_kSensorsHudEnabled) ?? false;
    notifyListeners();
  }

  Future<void> setBatteryThemeEnabled(bool v) async {
    _batteryThemeEnabled = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBatteryThemeEnabled, v);
  }

  Future<void> setBatteryThemeThreshold(int v) async {
    _batteryThemeThreshold = v.clamp(10, 100);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBatteryThemeThreshold, _batteryThemeThreshold);
  }

  Future<void> setSensorsHudEnabled(bool v) async {
    _sensorsHudEnabled = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSensorsHudEnabled, v);
  }
}
