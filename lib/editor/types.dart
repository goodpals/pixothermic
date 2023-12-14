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

typedef EditorActionCallback = void Function(EditorAction action);

sealed class EditorAction {
  const EditorAction();
}

class ActionSetId extends EditorAction {
  final String id;
  const ActionSetId({required this.id});
}

class ActionSetTitle extends EditorAction {
  final String? title;
  const ActionSetTitle({required this.title});
}

class ActionSetAuthor extends EditorAction {
  final String? author;
  const ActionSetAuthor({required this.author});
}
