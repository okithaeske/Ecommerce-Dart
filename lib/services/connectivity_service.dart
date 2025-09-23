import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  ConnectivityService() {
    _subscription = _connectivity.onConnectivityChanged.listen(_onStatus);
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _setOnline(_anyOnline(results));
  }

  void _onStatus(List<ConnectivityResult> results) {
    _setOnline(_anyOnline(results));
  }

  bool _anyOnline(List<ConnectivityResult> results) {
    // Consider mobile/wifi/ethernet/vpn as online
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
  }

  void _setOnline(bool v) {
    if (_isOnline != v) {
      _isOnline = v;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
