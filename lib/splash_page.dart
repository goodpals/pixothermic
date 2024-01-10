import 'package:flutter/material.dart';
import 'package:hot_cold/home_page.dart';
import 'package:hot_cold/locator.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton.outlined(
          onPressed: () {
            music().playMusicLoop();
            levelStore().loadAllCampaignLevels(context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
          },
          icon: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.fireplace_rounded),
          ),
          iconSize: 64,
        ),
      ),
    );
  }
}
