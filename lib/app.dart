import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_cold/locator.dart';
import 'package:hot_cold/splash_page.dart';
import 'package:hot_cold/store/level_store.dart';
import 'package:hot_cold/store/progress_store.dart';
import 'package:hot_cold/store/settings_store.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LevelStore>(
          create: (_) => levelStore(),
        ),
        BlocProvider<ProgressStore>(
          create: (_) => progress(),
        ),
        BlocProvider<SettingsStore>(
          create: (_) => settings(),
        ),
      ],
      child: MaterialApp(
        title: 'Hot/Cold',
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: PointerDeviceKind.values.toSet(),
        ),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
          textTheme: GoogleFonts.ubuntuTextTheme(),
        ),
      ),
    );
  }
}
