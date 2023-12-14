import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:hot_cold/editor/editor_page.dart';
import 'package:hot_cold/editor/panel.dart';
import 'package:hot_cold/utils/misc.dart';

class MetadataPanel extends StatefulWidget {
  final String id;
  final String? title;
  final String? author;
  final int version;
  final EditorActionCallback onAction;

  const MetadataPanel({
    super.key,
    required this.id,
    this.title,
    this.author,
    required this.version,
    required this.onAction,
  });

  @override
  State<MetadataPanel> createState() => _MetadataPanelState();
}

class _MetadataPanelState extends State<MetadataPanel> {
  late final _idController = TextEditingController(text: widget.id);
  late final _titleController = TextEditingController(text: widget.title);
  late final _authorController = TextEditingController(text: widget.author);

  @override
  void didUpdateWidget(covariant MetadataPanel oldWidget) {
    if (oldWidget.id != widget.id) {
      _idController.text = widget.id;
    }
    if (oldWidget.title != widget.title) {
      _titleController.text = widget.title ?? '';
    }
    if (oldWidget.author != widget.author) {
      _authorController.text = widget.author ?? '';
    }
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  void _updateId() => widget.onAction(ActionSetId(id: _idController.text));

  void _updateTitle() =>
      widget.onAction(ActionSetTitle(title: _titleController.text));

  void _updateAuthor() =>
      widget.onAction(ActionSetAuthor(author: _authorController.text));

  void _randomiseId() {
    _idController.text = generateIdPhrase();
    _updateId();
  }

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'id',
                suffixIcon: IconButton(
                  onPressed: _randomiseId,
                  icon: const Icon(MdiIcons.dice5),
                ),
              ),
              validator: (value) => switch (value) {
                null => null,
                String v
                    when v.length < idMinLength || v.length > idMaxLength =>
                  'ID length must be between $idMinLength and $idMaxLength',
                String v when !isValidId(v) =>
                  'Invalid ID: only a-z, 0-9 and _ allowed',
                _ => null,
              },
              onEditingComplete: _updateId,
              onFieldSubmitted: (_) => _updateId(),
              onChanged: (_) => _updateId(),
              maxLength: 32,
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'title',
              ),
              onEditingComplete: _updateTitle,
              onSubmitted: (_) => _updateTitle(),
              onChanged: (_) => _updateTitle(),
              maxLength: 64,
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'author',
              ),
              onEditingComplete: _updateAuthor,
              onSubmitted: (_) => _updateAuthor(),
              onChanged: (_) => _updateAuthor(),
              maxLength: 64,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'version ${widget.version}',
                  style: const TextStyle(color: Colors.white24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
