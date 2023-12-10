import 'package:flutter/material.dart';
import 'package:hot_cold/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hot/Cold',
      home: HomePage(),
    );
  }
}
