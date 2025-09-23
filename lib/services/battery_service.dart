import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';

class BatteryService extends ChangeNotifier {
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _stateSub;
  Timer? _levelTimer;

  int? _level;
  BatteryState? _state;

  int? get level => _level;
  BatteryState? get state => _state;
  bool get isCharging => _state == BatteryState.charging;
  bool get isFull => _state == BatteryState.full;
  bool get isLowBattery => (_level != null && _level! <= 20) && !isCharging;

  BatteryService() {
    _init();
  }

  Future<void> _init() async {
    await _refreshLevel();
    try {
      _stateSub = _battery.onBatteryStateChanged.listen((s) {
        _state = s;
        notifyListeners();
      });
    } catch (_) {}
    _levelTimer = Timer.periodic(const Duration(minutes: 1), (_) => _refreshLevel());
  }

  Future<void> _refreshLevel() async {
    try {
      final lvl = await _battery.batteryLevel;
      if (_level != lvl) {
        _level = lvl;
        notifyListeners();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _levelTimer?.cancel();
    super.dispose();
  }
}

