import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class BackupService {
  Future<String> backup() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = await FilePicker.platform.getDirectoryPath();

      if (backupDir == null) {
        return 'Backup cancelled.';
      }

      final files = appDir.listSync().where((item) => item.path.endsWith('.md'));
      int count = 0;
      for (var file in files) {
        if (file is File) {
          final newPath = p.join(backupDir, p.basename(file.path));
          await file.copy(newPath);
          count++;
        }
      }
      return 'Backed up $count deck(s) successfully.';
    } catch (e) {
      return 'Backup failed: $e';
    }
  }

  Future<String> restore() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = await FilePicker.platform.getDirectoryPath();

      if (backupDir == null) {
        return 'Restore cancelled.';
      }

      final backupDirectory = Directory(backupDir);
      final files = backupDirectory.listSync().where((item) => item.path.endsWith('.md'));

      int count = 0;
      for (var file in files) {
        if (file is File) {
          final newPath = p.join(appDir.path, p.basename(file.path));
          await file.copy(newPath);
          count++;
        }
      }
      return 'Restored $count deck(s) successfully. Please restart the app or refresh the deck list.';
    } catch (e) {
      return 'Restore failed: $e';
    }
  }
}
