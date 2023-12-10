part of 'editor_page.dart';

enum EditorLayer {
  foreground,
  entities;
}

sealed class EditorBrush extends Equatable {}

class BrushForeground extends EditorBrush {
  final String spritePath;
  BrushForeground(this.spritePath);

  @override
  List<Object> get props => [spritePath];
}

class BrushEntity extends EditorBrush {
  final EntityType entityType;
  BrushEntity(this.entityType);

  @override
  List<Object> get props => [entityType];
}

class BrushWater extends EditorBrush {
  @override
  List<Object> get props => [];
}
