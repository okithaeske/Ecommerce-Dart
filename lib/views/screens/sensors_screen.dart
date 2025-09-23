import 'dart:math' as math;
import 'dart:async';

import 'package:ecommerce/services/permissions_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
// Battery/motion sensors not displayed in this demo page

import 'scanner_screen.dart';
import 'search_results_screen.dart';

class SensorsScreen extends StatefulWidget {
  const SensorsScreen({super.key});

  @override
  State<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  Position? _position;
  String? _voiceText;
  bool _listening = false;
  late final stt.SpeechToText _speech;
  String? _localeId;

  // Battery/motion removed from Sensors demo screen UI

  // Example store location (Kandy, Sri Lanka approx.)
  static const double _storeLat = 7.2906;
  static const double _storeLng = 80.6337;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _localeId = prefs.getString('asr_locale');
    });
  }

  // (Battery/motion setup removed)

  Future<void> _getLocation() async {
    final ok = await PermissionsService.ensureLocation();
    if (!ok) {
      _showSnack('Location permission required');
      return;
    }
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnack('Enable Location Services to proceed');
      return;
    }
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    setState(() => _position = pos);
  }

  double _distanceMeters(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // meters
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(_deg2rad(lat1)) * math.cos(_deg2rad(lat2)) *
                math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double d) => d * (math.pi / 180.0);

  Future<void> _scan() async {
    final ok = await PermissionsService.ensureCamera();
    if (!ok) {
      _showSnack('Camera permission required');
      return;
    }
    if (!mounted) return;
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );
    if (code != null && code.isNotEmpty && mounted) {
      _showSnack('Scanned: $code');
      // Here you could: lookup product by SKU/QR and navigate
    }
  }

  Future<void> _voice() async {
    final mic = await PermissionsService.ensureMicrophone();
    if (!mic) {
      _showSnack('Microphone permission required');
      return;
    }
    if (!_listening) {
      final available = await _speech.initialize(onError: (e) {}, onStatus: (s) {});
      if (!available) {
        _showSnack('Speech recognition not available');
        return;
      }
      setState(() => _listening = true);
      String? finalText;
      await _speech.listen(
        onResult: (result) {
          setState(() => _voiceText = result.recognizedWords);
          if (result.finalResult) {
            finalText = result.recognizedWords;
          }
        },
        pauseFor: const Duration(seconds: 2),
        listenOptions: stt.SpeechListenOptions(partialResults: true),
        localeId: _localeId,
      );
      await Future.delayed(const Duration(milliseconds: 400));
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      final text = (finalText ?? _voiceText)?.trim();
      if (mounted && text != null && text.isNotEmpty) {
        _showSnack('Voice: $text');
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SearchResultsScreen(query: text)),
        );
      }
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final dist = (_position == null)
        ? null
        : _distanceMeters(
            _position!.latitude,
            _position!.longitude,
            _storeLat,
            _storeLng,
          );
    final inStore = dist != null && dist < 150.0; // 150m radius demo

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Sensors Demo'),
        backgroundColor: cs.surface,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('asr_locale', value);
              setState(() => _localeId = value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'en_US', child: Text('English (US)')),
              PopupMenuItem(value: 'en_GB', child: Text('English (UK)')),
              PopupMenuItem(value: 'si_LK', child: Text('Sinhala (LK)')),
              PopupMenuItem(value: 'hi_IN', child: Text('Hindi (IN)')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Tile(
              title: 'Location / In-Store Mode',
              subtitle: _position == null
                  ? 'Tap to get current location'
                  : 'You are ${dist!.toStringAsFixed(0)}m from store • ${inStore ? 'IN STORE' : 'AWAY'}',
              icon: Icons.place_outlined,
              color: cs.primary,
              onTap: _getLocation,
            ),
            const SizedBox(height: 12),
            _Tile(
              title: 'Scan Product / Coupon',
              subtitle: 'Open camera to scan barcode or QR',
              icon: Icons.qr_code_scanner,
              color: cs.primary,
              onTap: _scan,
            ),
            const SizedBox(height: 12),
            _Tile(
              title: _listening ? 'Listening…' : 'Voice Search',
              subtitle: _voiceText == null || _voiceText!.isEmpty
                  ? 'Tap and speak your product'
                  : 'Heard: "$_voiceText"',
              icon: Icons.mic_none,
              color: cs.primary,
              onTap: _voice,
            ),
            // Battery and motion tiles intentionally not shown here
            const Spacer(),
            Text(
              'Note: Permissions requested per feature. Data is not stored.',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  // (Helpers and subscriptions removed; default dispose is sufficient)
}

class _Tile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _Tile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
