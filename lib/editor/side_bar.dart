import 'package:flutter/material.dart';
import 'package:hot_cold/editor/panel.dart';
import 'package:hot_cold/models/entities.dart';
import 'package:hot_cold/models/sprites.dart';

import 'editor_page.dart';
import 'metadata_panel.dart';
import 'sun_panel.dart';
import 'water_panel.dart';

class EditorSideBar extends StatelessWidget {
  final String id;
  final String? title;
  final String? author;
  final int version;
  final void Function(EditorBrush? action) onChangeAction;
  final EditorBrush? currentAction;
  final Color waterColour;
  final Color sunColour;
  final num sunAngle;
  final void Function(Color) onSetWaterColour;
  final void Function(Color) onSetSunColour;
  final void Function(double) onSetSunAngle;
  final EditorActionCallback onAction;

  const EditorSideBar({
    super.key,
    required this.id,
    this.title,
    this.author,
    required this.version,
    required this.onChangeAction,
    this.currentAction,
    required this.waterColour,
    required this.sunColour,
    required this.sunAngle,
    required this.onSetWaterColour,
    required this.onSetSunColour,
    required this.onSetSunAngle,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final activeColour = Colors.orange.shade300;
    return LayoutBuilder(builder: (context, constraints) {
      return Theme(
        data: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: activeColour,
                displayColor: activeColour,
              ),
          iconTheme: Theme.of(context).iconTheme.copyWith(
                color: activeColour,
              ),
        ),
        child: Container(
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
              MetadataPanel(
                id: id,
                title: title,
                author: author,
                version: version,
                onAction: onAction,
              ),
              Panel(
                title: 'Tiles',
                icon: const Icon(Icons.texture),
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
                title: 'Entities',
                icon: const Icon(Icons.emoji_objects),
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
                sunAngle: sunAngle.toDouble(),
                onSetSunAngle: onSetSunAngle,
              ),
              Panel(
                child: Text(
                  '''
        Q/Left Click: Place tile
        W/Right Click: Remove tile
        ''',
                  style: TextStyle(
                    color: activeColour,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
