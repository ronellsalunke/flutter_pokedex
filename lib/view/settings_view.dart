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
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: themeViewModel.isDark,
            onChanged: (value) {
              themeViewModel.toggleTheme(value);
            },
          ),
        ],
      ),
    );
  }
}
