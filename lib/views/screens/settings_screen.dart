import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/routes/app_route.dart';
import 'package:ecommerce/services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final settings = context.watch<SettingsService>();
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: cs.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: cs.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Battery-based Dark Mode',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SwitchListTile(
                    value: settings.batteryThemeEnabled,
                    onChanged:
                        (v) => context
                            .read<SettingsService>()
                            .setBatteryThemeEnabled(v),
                    title: const Text('Enable'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  Opacity(
                    opacity: settings.batteryThemeEnabled ? 1 : 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Threshold'),
                            Text('${settings.batteryThemeThreshold}%'),
                          ],
                        ),
                        Slider(
                          value: settings.batteryThemeThreshold.toDouble(),
                          min: 20,
                          max: 100,
                          divisions: 16,
                          label: '${settings.batteryThemeThreshold}%',
                          onChanged:
                              settings.batteryThemeEnabled
                                  ? (v) => context
                                      .read<SettingsService>()
                                      .setBatteryThemeThreshold(v.round())
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: cs.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Floating Sensors HUD',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SwitchListTile(
                    value: settings.sensorsHudEnabled,
                    onChanged:
                        (v) => context
                            .read<SettingsService>()
                            .setSensorsHudEnabled(v),
                    title: const Text('Enable overlay'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Text(
                    'Shows draggable accelerometer/gyroscope and battery info on top of screens.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: cs.surfaceContainerHighest,
            child: ListTile(
              leading: Icon(Icons.favorite_outline, color: cs.primary),
              title: Text(
                'Wishlist',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Review or share saved products'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.wishlist);
              },
            ),
          ),
          Card(
            color: cs.surfaceContainerHighest,
            child: ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text(
                'Log out',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
