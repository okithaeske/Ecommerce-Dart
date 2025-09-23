import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SyncQueueService {
  SyncQueueService._() {
    _init();
  }

  static final SyncQueueService instance = SyncQueueService._();

  final _connectivity = Connectivity();
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  StreamSubscription<List<ConnectivityResult>>? _sub;

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = _anyOnline(results);
    _sub = _connectivity.onConnectivityChanged.listen((results) async {
      final nowOnline = _anyOnline(results);
      _isOnline = nowOnline;
      if (nowOnline) {
        await processPending();
      }
    });
  }

  bool _anyOnline(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
  }

  Box get _box => Hive.box('sync_queue');

  Future<void> enqueue({required String type, required Map<String, dynamic> payload}) async {
    final item = {
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'type': type,
      'payload': payload,
      'createdAt': DateTime.now().toIso8601String(),
    };
    await _box.add(item);
  }

  Future<void> processPending() async {
    // Placeholder processor: mark all as processed successfully.
    // Integrate with real APIs by iterating and dispatching per type.
    final entries = _box.values.toList();
    if (entries.isEmpty) return;
    // In a real app, dispatch each action and only remove on success.
    await _box.clear();
  }

  void dispose() {
    _sub?.cancel();
  }
}

