import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_cold/home_page.dart';
import 'package:hot_cold/locator.dart';
import 'package:hot_cold/store/progress_store.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProgressStore>(
          create: (_) => progress(),
        ),
      ],
      child: MaterialApp(
        title: 'Hot/Cold',
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          // Mouse dragging enabled for this demo
          dragDevices: PointerDeviceKind.values.toSet(),
        ),
      ),
    );
  }
}
