import 'dart:io';
import "package:path/path.dart" show dirname, join;

void main(List<String> args) async {


  final file = File(join(dirname(Platform.script.toFilePath()),'diagnostic-messages.md'));

  if (!file.existsSync()) {
    print('Error: File does not exist.');
    exit(1);
  }

  final content = await file.readAsString();

  // Substituir hifens por underscores dentro de {:#...}
  final updatedContent = content.replaceAllMapped(
    RegExp(r'\{:#([a-z0-9]+(?:-[a-z0-9]+)*)\}'),
    (match) {
      final original = match.group(1)!;
      final modified = original.replaceAll('-', '_');
      return '{:#$modified}';
    },
  );

  await file.writeAsString(updatedContent);
}
