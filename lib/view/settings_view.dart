import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dex/viewmodel/theme_viewmodel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Theme",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.maxFinite,
              child: SegmentedButton<AppThemeMode>(
                segments: const [
                  ButtonSegment<AppThemeMode>(
                    value: AppThemeMode.system,
                    label: Text('System'),
                    icon: Icon(Icons.brightness_auto),
                  ),
                  ButtonSegment<AppThemeMode>(
                    value: AppThemeMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.light_mode),
                  ),
                  ButtonSegment<AppThemeMode>(
                    value: AppThemeMode.dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.dark_mode),
                  ),
                ],
                selected: {themeViewModel.themeMode},
                onSelectionChanged: (Set<AppThemeMode> selection) {
                  if (selection.isNotEmpty) {
                    themeViewModel.setThemeMode(selection.first);
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text("Enable Dynamic Colors"),
              subtitle: const Text("Adapt to your wallpaper colors (Android 12+)"),
              value: themeViewModel.dynamicColors,
              onChanged: (value) {
                themeViewModel.setDynamicColors(value);
              },
            ),
            const SizedBox(height: 8),
            Text(
              "Dynamic colors adapt your app's theme to match your wallpaper colors",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
