import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/levels.dart';
import 'package:nice_json/nice_json.dart';

class LevelStore extends Cubit<LevelStoreState> {
  // Why are we storing levels as JSON, instead of Hive objects, you ask?
  // Well that's because Hive is basically abandoned
  // and doesn't support records!
  late final Box<String> box;
  Map<int, LevelData> campaignLevels = {};
  Map<String, LevelData> customLevels = {};

  LevelStore() : super(LevelStoreState.initial()) {
    _init();
  }

  void _init() async {
    box = await Hive.openBox('levels');
    _loadAllLocalLevels();
  }

  // digusting but who cares
  void _emit() => emit(
        LevelStoreState(
          campaignLevels: campaignLevels,
          customLevels: customLevels,
        ),
      );

  Future<void> loadAllCampaignLevels(BuildContext context) async {
    for (final (i, _) in campaignLevelPaths.indexed) {
      await loadCampaignLevel(context, i);
    }
    _emit();
  }

  // kinda gross but whatever
  Future<LevelData> loadCampaignLevel(BuildContext context, int index) async {
    if (!campaignLevels.containsKey(index)) {
      final json = await DefaultAssetBundle.of(context)
          .loadString('assets/levels/${campaignLevelPaths[index]}');
      campaignLevels[index] = LevelData.fromJson(
        jsonDecode(json),
        isCampaign: true,
      );
      // idk maybe
      // unawaited(saveLevelLocal(campaignLevels[index]!, allowCampaign: true));
    }
    return campaignLevels[index]!;
  }

  void _loadAllLocalLevels() {
    for (final level in box.values) {
      final levelData = LevelData.fromJson(jsonDecode(level));
      customLevels[levelData.id] = levelData;
    }
    _emit();
  }

  /// Return value is an error.
  Future<String?> saveLevelLocal(
    LevelData level, {
    bool allowCampaign = false,
  }) async {
    if (!allowCampaign && level.id.startsWith('campaign_')) {
      return 'Reserved ID (${level.id})';
    }
    customLevels[level.id] = level;
    _emit();
    await box.put(level.id, niceJson(level.toJson()));
    return null;
  }
}

class LevelStoreState {
  final Map<int, LevelData> campaignLevels;
  final Map<String, LevelData> customLevels;

  const LevelStoreState({
    required this.campaignLevels,
    required this.customLevels,
  });

  factory LevelStoreState.initial() => const LevelStoreState(
        campaignLevels: {},
        customLevels: {},
      );
}
