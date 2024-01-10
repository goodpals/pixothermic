import 'dart:convert' show utf8;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show AnchorElement;

void saveTextFileWeb({
  required String filename,
  required String text,
  String mimeType = 'application/json',
}) {
  final element = AnchorElement(
    href: '${Uri.dataFromString(text, mimeType: mimeType, encoding: utf8)}',
  );
  element.download = filename;
  element.style.display = 'none';
  element.click();
}
