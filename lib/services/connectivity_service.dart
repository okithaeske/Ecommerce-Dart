import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectivityService extends ChangeNotifier {
  ConnectivityService() {
    _subscription = _connectivity.onConnectivityChanged.listen(_handleStatus);
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  final NetworkInfo _networkInfo = NetworkInfo();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  bool _isOnline = true;
  ConnectivityResult? _activeResult;
  String? _wifiName;
  String? _ipAddress;

  bool get isOnline => _isOnline;
  ConnectivityResult? get activeResult => _activeResult;
  String? get wifiName => _wifiName;
  String? get ipAddress => _ipAddress;

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    await _applyStatus(results);
  }

  void _handleStatus(List<ConnectivityResult> results) {
    _applyStatus(results);
  }

  Future<void> _applyStatus(List<ConnectivityResult> results) async {
    final filtered = results.where((r) => r != ConnectivityResult.vpn).toList();
    final primary =
        filtered.isNotEmpty
            ? filtered.first
            : (results.isNotEmpty ? results.first : ConnectivityResult.none);
    final isOnline = _anyOnline(results);

    String? wifiName;
    String? ipAddress;
    if (isOnline && primary != ConnectivityResult.none) {
      try {
        if (primary == ConnectivityResult.wifi) {
          wifiName = await _networkInfo.getWifiName();
          ipAddress = await _networkInfo.getWifiIP();
        } else {
          ipAddress = await _firstNonLoopbackIp();
          if (primary == ConnectivityResult.vpn) {
            wifiName = await _networkInfo.getWifiName();
          }
        }
      } catch (_) {
        // Ignore platform exceptions; fallback to nulls.
      }
    }

    var changed = false;
    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      changed = true;
    }
    if (_activeResult != primary) {
      _activeResult = primary;
      changed = true;
    }
    if (_wifiName != wifiName) {
      _wifiName = wifiName;
      changed = true;
    }
    if (_ipAddress != ipAddress) {
      _ipAddress = ipAddress;
      changed = true;
    }
    if (changed) {
      notifyListeners();
    }
  }

  bool _anyOnline(List<ConnectivityResult> results) {
    return results.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn,
    );
  }

  Future<String?> _firstNonLoopbackIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
        includeLinkLocal: false,
      );
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (!addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (_) {
      // Ignore failures and return null.
    }
    return null;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
