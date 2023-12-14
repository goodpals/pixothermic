import 'package:fluttering_phrases/fluttering_phrases.dart' as fp;

final _fpNouns = [...fp.defaultNouns.where((e) => e.length <= 12)];
final _fpAttr = [...fp.defaultAttributives.where((e) => e.length <= 12)];
String generateIdPhrase() =>
    fp.generate(delimiter: '_', nouns: _fpNouns, attributives: _fpAttr);
final _idRegex = RegExp(r'^[a-z0-9_]+$');
const int idMinLength = 8;
const int idMaxLength = 32;
const int titleMaxLength = 64;
bool isValidId(String id) =>
    _idRegex.hasMatch(id) &&
    id.length <= idMaxLength &&
    id.length >= idMinLength;
