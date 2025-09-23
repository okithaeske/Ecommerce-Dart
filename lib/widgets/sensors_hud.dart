import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:ecommerce/services/battery_service.dart';

class SensorsHud extends StatefulWidget {
  const SensorsHud({super.key});

  @override
  State<SensorsHud> createState() => _SensorsHudState();
}

class _SensorsHudState extends State<SensorsHud> {
  Offset _offset = const Offset(16, 140);
  AccelerometerEvent? _accel;
  GyroscopeEvent? _gyro;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEventStream().listen((e) {
      if (!mounted) return;
      setState(() => _accel = e);
    });
    _gyroSub = gyroscopeEventStream().listen((e) {
      if (!mounted) return;
      setState(() => _gyro = e);
    });
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final battery = context.watch<BatteryService>();
    final lvl = battery.level;
    final charging = battery.isCharging;

    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: GestureDetector(
        onPanUpdate: (d) {
          final size = MediaQuery.of(context).size;
          final newX = (_offset.dx + d.delta.dx).clamp(0.0, size.width - 180);
          final newY = (_offset.dy + d.delta.dy).clamp(80.0, size.height - 140);
          setState(() => _offset = Offset(newX, newY));
        },
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: cs.shadow.withValues(alpha: 0.2), blurRadius: 8)],
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: cs.onSurface, fontSize: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.sensors, size: 16, color: cs.primary),
                    const SizedBox(width: 6),
                    const Text('Sensors HUD', style: TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Icon(Icons.drag_indicator, size: 14, color: cs.onSurfaceVariant),
                  ],
                ),
                const SizedBox(height: 6),
                Text(_accel == null
                    ? 'Accel: —'
                    : 'Accel x:${_accel!.x.toStringAsFixed(2)} y:${_accel!.y.toStringAsFixed(2)} z:${_accel!.z.toStringAsFixed(2)}'),
                Text(_gyro == null
                    ? 'Gyro: —'
                    : 'Gyro x:${_gyro!.x.toStringAsFixed(2)} y:${_gyro!.y.toStringAsFixed(2)} z:${_gyro!.z.toStringAsFixed(2)}'),
                Text('Battery: ${lvl == null ? '—' : '$lvl%'}${charging ? ' (charging)' : ''}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

