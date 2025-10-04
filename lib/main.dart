import 'package:flutter/material.dart';
import 'package:flutter_dex/res/assets.dart';
import 'package:flutter_dex/view/home_view.dart';
import 'package:flutter_dex/viewmodel/home_viewmodel.dart';
import 'package:flutter_dex/viewmodel/theme_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _buildTheme(Brightness brightness, bool dynamicColors, ColorScheme? dynamicColorScheme) {
    ColorScheme colorScheme;
    
    if (dynamicColors && dynamicColorScheme != null) {
      // use M3 dynamic colors when available A12+
      colorScheme = dynamicColorScheme;
    } else {
      // fallback to default color scheme
      colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: brightness,
      );
    }
    
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: Assets.font,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, _) {
          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              return MaterialApp(
                title: 'FlutterDex',
                debugShowCheckedModeBanner: false,
                theme: _buildTheme(
                  Brightness.light, 
                  themeViewModel.dynamicColors, 
                  lightDynamic,
                ),
                darkTheme: _buildTheme(
                  Brightness.dark, 
                  themeViewModel.dynamicColors, 
                  darkDynamic,
                ),
                themeMode: themeViewModel.currentTheme,
                home: const HomeView(),
              );
            },
          );
        },
      ),
    );
  }
}
