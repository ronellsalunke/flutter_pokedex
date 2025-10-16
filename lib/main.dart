import 'package:flutter/material.dart';
import 'package:flutter_dex/data/cache/cache_service.dart';
import 'package:flutter_dex/res/assets.dart';
import 'package:flutter_dex/view/home_view.dart';
import 'package:flutter_dex/viewmodel/home_viewmodel.dart';
import 'package:flutter_dex/viewmodel/theme_viewmodel.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  final cacheService = CacheService();
  await cacheService.init();

  runApp(MyApp(cacheService: cacheService));
}

class MyApp extends StatefulWidget {
  final CacheService cacheService;

  const MyApp({super.key, required this.cacheService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _buildTheme(
    Brightness brightness,
    bool dynamicColors,
    ColorScheme? dynamicColorScheme,
  ) {
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
        Provider<CacheService>.value(value: widget.cacheService),
        ChangeNotifierProvider(
          create:
              (context) => HomeViewModel(
                Provider.of<CacheService>(context, listen: false),
              ),
        ),
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
