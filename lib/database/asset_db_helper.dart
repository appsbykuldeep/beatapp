import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AssetDbHelper {
  Database? db;
  bool initialized = false;

/*Create Db*/
  Future<void> createDB() async {
    // Construct a file path to copy database to
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "beat_app_db.db");
// Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data =
          await rootBundle.load(join('assets', 'db/beat_app_db.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await File(path).writeAsBytes(bytes);
    }
  }

  openDataBaseConnection() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'beat_app_db.db');
    db = await openDatabase(databasePath);
    initialized = true;
  }

  closeDataBaseConnection() {
    db!.close();
    initialized = false;
  }
}
