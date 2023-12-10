import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/levels.dart';

class LevelStore {
  Map<int, LevelData> campaignLevels = {};

  LevelStore();

  // kinda gross but whatever
  Future<LevelData> loadCampaignLevel(BuildContext context, int index) async {
    if (!campaignLevels.containsKey(index)) {
      final json = await DefaultAssetBundle.of(context)
          .loadString("assets/levels/${campaignLevelPaths[index]}");
      campaignLevels[index] = LevelData.fromJson(jsonDecode(json));
    }
    return campaignLevels[index]!;
  }
}
