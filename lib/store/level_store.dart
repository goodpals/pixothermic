import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/levels.dart';

class LevelStore {
  Map<int, LevelData> campaignLevels = {};

  LevelStore();

  Future<void> loadAllCampaignLevels(BuildContext context) async {
    for (final (i, _) in campaignLevelPaths.indexed) {
      await loadCampaignLevel(context, i);
    }
  }

  // kinda gross but whatever
  Future<LevelData> loadCampaignLevel(BuildContext context, int index) async {
    if (!campaignLevels.containsKey(index)) {
      final json = await DefaultAssetBundle.of(context)
          .loadString("assets/levels/${campaignLevelPaths[index]}");
      campaignLevels[index] = LevelData.fromJson(
        jsonDecode(json),
        isCampaign: true,
      );
    }
    return campaignLevels[index]!;
  }
}
