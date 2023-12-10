import 'dart:convert';
import 'dart:developer';

import 'package:elegant/elegant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hot_cold/editor/load_json_dialog.dart';
import 'package:hot_cold/editor/panel.dart';
import 'package:hot_cold/editor/sun_panel.dart';
import 'package:hot_cold/editor/water_panel.dart';
import 'package:hot_cold/game_page.dart';
import 'package:hot_cold/models/entities.dart';
import 'package:hot_cold/models/level_data.dart';
import 'package:hot_cold/models/sprites.dart';
import 'package:hot_cold/models/types.dart';
import 'package:hot_cold/widgets/two_dimensional_grid_view.dart';
import 'package:equatable/equatable.dart';
import 'package:nice_json/nice_json.dart';

part 'types.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  Map<IntVec, String> foreground = {};
  Map<IntVec, EntityType> entities = {};
  Map<IntVec, EditorBrush> tiles = {};

  EditorBrush? brush;
  IntVec? currentTile;

  Color sunColour = Colors.amber.shade400;
  Color waterColour = Colors.indigo.shade400;

  double sunAngle = 0;

  IntVec? get spawn => tiles.entries
      .where(
        (e) => e.value.asType<BrushEntity>()?.entityType == EntityType.spawn,
      )
      .firstOrNull
      ?.key;

  IntVec? get goal => tiles.entries
      .where(
        (e) => e.value.asType<BrushEntity>()?.entityType == EntityType.goal,
      )
      .firstOrNull
      ?.key;

  void _setEditorAction(EditorBrush? action) => setState(() => brush = action);

  void _onEnterTile(IntVec tile) => setState(() => currentTile = tile);
  void _onExitTile(IntVec tile) {
    if (tile == currentTile) setState(() => currentTile = null);
  }

  void _onTapTile(IntVec tile) =>
      brush == null ? tiles.remove(tile) : tiles[tile] = brush!;

  void _onSecondaryTapTile(IntVec tile) => setState(() => tiles.remove(tile));

  LevelData? _validateLevel() {
    final (level, error) = _buildLevelData();
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
    return level;
  }

  void _startLevel() {
    final level = _validateLevel();
    if (level == null) return;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => GamePage(level: level)));
  }

  void _copyLevelData() {
    final level = _validateLevel();
    if (level == null) return;
    Clipboard.setData(ClipboardData(text: niceJson(level.toJson())));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied level JSON to clipboard')));
  }

  void _showLoadFromJsonDialog() async {
    final json = await showDialog(
      context: context,
      builder: (context) => const LoadJsonDialog(),
    );
    try {
      final level = LevelData.fromJson(jsonDecode(json));
      setState(() {
        tiles = {
          for (final e in level.foreground.entries)
            e.key: BrushForeground(e.value),
          for (final e in level.entities.entries) e.key: BrushEntity(e.value),
          for (final e in level.water.entries) e.key: BrushWater(),
          level.spawn: BrushEntity(EntityType.spawn),
          level.goal: BrushEntity(EntityType.goal),
        };
        sunAngle = level.sunAngle;
        sunColour = level.sunColour;
        waterColour = level.waterColour;
      });
    } catch (e, s) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid level JSON: $e')));
      log('Invalid level JSON: $e\n$s');
    }
  }

  (LevelData?, String?) _buildLevelData() {
    if (spawn == null) return (null, 'Missing spawn');
    if (goal == null) return (null, 'Missing goal');
    final fgTiles = {...tiles};
    fgTiles.removeWhere((k, v) => v is! BrushForeground);
    final entities = {...tiles};
    entities.removeWhere((k, v) => v is! BrushEntity);
    entities.remove(spawn);
    entities.remove(goal);
    final level = LevelData(
      spawn: spawn!,
      goal: goal!,
      foreground: {
        for (final t in fgTiles.entries)
          t.key: t.value.asType<BrushForeground>()!.spritePath,
      },
      entities: {
        for (final t in entities.entries)
          t.key: t.value.asType<BrushEntity>()!.entityType,
      },
      water: {
        for (final t in tiles.entries)
          if (t.value is BrushWater) t.key: 1.0,
      },
      sunAngle: sunAngle,
      sunColour: sunColour,
      waterColour: waterColour,
    );
    return (level, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: currentTile == null ? null : Text('$currentTile'),
        actions: [
          IconButton(
            onPressed: _showLoadFromJsonDialog,
            icon: const Icon(Icons.file_download),
          ),
          IconButton(
            onPressed: _copyLevelData,
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            onPressed: _startLevel,
            icon: const Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ): () {
            if (currentTile != null) _onTapTile(currentTile!);
          },
          const SingleActivator(LogicalKeyboardKey.keyW): () {
            if (currentTile != null) _onSecondaryTapTile(currentTile!);
          }
        },
        child: Focus(
          autofocus: true,
          child: Center(
            child: Row(
              children: [
                ObjectPalette(
                  onChangeAction: _setEditorAction,
                  currentAction: brush,
                  waterColour: waterColour,
                  sunColour: sunColour,
                  sunAngle: sunAngle,
                  onSetWaterColour: (c) => setState(() => waterColour = c),
                  onSetSunColour: (c) => setState(() => sunColour = c),
                  onSetSunAngle: (a) => setState(() => sunAngle = a),
                ),
                Expanded(
                  child: TwoDimensionalGridView(
                    itemSize: 32,
                    diagonalDragBehavior: DiagonalDragBehavior.free,
                    delegate: TwoDimensionalChildBuilderDelegate(
                        maxXIndex: 200,
                        maxYIndex: 200,
                        builder: (context, vicinity) {
                          final pos = (vicinity.xIndex, vicinity.yIndex);
                          return _GameGridTile(
                            content: tiles[pos],
                            position: pos,
                            size: 32,
                            onMouseEnter: (_) => _onEnterTile(pos),
                            onMouseExit: (_) => _onExitTile(pos),
                            onTap: () => _onTapTile(pos),
                            onSecondaryTap: () => _onSecondaryTapTile(pos),
                            waterColour: waterColour,
                          );
                        }),
                  ),
                ),
                // Expanded(child: GameWidget<LevelEditor>(game: levelEditor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ObjectPalette extends StatelessWidget {
  final void Function(EditorBrush? action) onChangeAction;
  final EditorBrush? currentAction;
  final Color waterColour;
  final Color sunColour;
  final double sunAngle;
  final void Function(Color) onSetWaterColour;
  final void Function(Color) onSetSunColour;
  final void Function(double) onSetSunAngle;

  const ObjectPalette({
    super.key,
    required this.onChangeAction,
    this.currentAction,
    required this.waterColour,
    required this.sunColour,
    required this.sunAngle,
    required this.onSetWaterColour,
    required this.onSetSunColour,
    required this.onSetSunAngle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.blueGrey,
        width: 300,
        height: constraints.maxHeight,
        child: ListView(
          children: [
            Panel(
              child: ElevatedButton(
                onPressed:
                    currentAction != null ? () => onChangeAction(null) : null,
                child: const Icon(Icons.clear),
              ),
            ),
            Panel(
              active: currentAction is BrushForeground,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 6,
                children: SpritePaths.foregroundTiles
                    .map((e) => SelectionTile(
                        content: BrushForeground(e),
                        onTap: () => onChangeAction(BrushForeground(e)),
                        selected: currentAction == BrushForeground(e)))
                    .toList(),
              ),
            ),
            Panel(
              active: currentAction is BrushEntity,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 6,
                children: EntityType.values
                    .map(
                      (e) => SelectionTile(
                          content: BrushEntity(e),
                          onTap: () => onChangeAction(BrushEntity(e)),
                          selected: currentAction == BrushEntity(e)),
                    )
                    .toList(),
              ),
            ),
            WaterPanel(
              active: currentAction is BrushWater,
              onSetActive: (v) => onChangeAction(
                v == true ? BrushWater() : null,
              ),
              colour: waterColour,
              onSetColour: onSetWaterColour,
            ),
            SunPanel(
              sunColour: sunColour,
              onSetSunColour: onSetSunColour,
              sunAngle: sunAngle,
              onSetSunAngle: onSetSunAngle,
            ),
            const Panel(
              child: Text(
                '''
Q/Left Click: Place tile
W/Right Click: Remove tile
''',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _GameGridTile extends StatelessWidget {
  final EditorBrush? content;
  final bool active;
  final IntVec position;
  final double size;
  final void Function(PointerEnterEvent?)? onMouseEnter;
  final void Function(PointerExitEvent?)? onMouseExit;
  final VoidCallback? onTap;
  final VoidCallback? onSecondaryTap;
  final Color waterColour;

  const _GameGridTile({
    this.content,
    this.active = false,
    required this.position,
    this.size = 32,
    this.onMouseEnter,
    this.onMouseExit,
    this.onTap,
    this.onSecondaryTap,
    required this.waterColour,
  });

  bool get altColour => position.$1 % 2 == position.$2 % 2;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onMouseEnter,
      onExit: onMouseExit,
      child: GestureDetector(
        onTap: onTap,
        onSecondaryTap: onSecondaryTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: active ? Border.all(color: Colors.yellow, width: 2) : null,
            image: switch (content) {
              null => null,
              BrushForeground(spritePath: final sprite) => DecorationImage(
                  image: AssetImage('assets/images/$sprite'),
                  fit: BoxFit.cover,
                ),
              BrushEntity(entityType: final type) => DecorationImage(
                  image: AssetImage('assets/images/${type.spritePath}'),
                  fit: BoxFit.cover,
                ),
              _ => null,
            },
            color: switch (content) {
              null =>
                altColour ? Colors.blueGrey.shade700 : Colors.blueGrey.shade600,
              BrushWater() => waterColour,
              _ => null,
            },
          ),
        ),
      ),
    );
  }
}

class SelectionTile extends StatelessWidget {
  final EditorBrush content;
  final bool selected;
  final VoidCallback? onTap;

  const SelectionTile({
    super.key,
    required this.content,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: Colors.yellow, width: 2) : null,
          image: switch (content) {
            BrushForeground(spritePath: final sprite) => DecorationImage(
                image: AssetImage('assets/images/$sprite'),
                fit: BoxFit.cover,
              ),
            BrushEntity(entityType: final type) => DecorationImage(
                image: AssetImage('assets/images/${type.spritePath}'),
                fit: BoxFit.cover,
              ),
            _ => null,
          },
          color: switch (content) {
            BrushWater() => Colors.blueGrey.shade900,
            _ => null,
          },
        ),
      ),
    );
  }
}
