import 'dart:io';

import 'package:beatapp/database/relation_type_map.dart';
import 'package:beatapp/entities/relation_type.dart';
import 'package:beatapp/entities/warrant_exec_type.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AssetDbHelper {
  static Database? db;
  static bool initialized = false;

  static String? _documentsDirectory;

  static List<RelationType> _allRelationTypesList = [];
  static List<WarrantExecType> _warrantExecTypeList = [];

  static List<RelationType> get allRelationTypesList =>
      [..._allRelationTypesList];
  static List<WarrantExecType> get warrantExecTypeList =>
      [..._warrantExecTypeList];

  static Future<void> createDB() async {
    _documentsDirectory ??= (await getApplicationDocumentsDirectory()).path;
    String path = join(_documentsDirectory!, "beat_app_db.db");
    final dbFile = File(path);

    if (!dbFile.existsSync()) {
      ByteData data =
          await rootBundle.load(join('assets', 'db/beat_app_db.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await dbFile.writeAsBytes(bytes);
    }

    await openDataBaseConnection();

    // Setting up basic data

    _baicDataList();
  }

  static Future<void> openDataBaseConnection() async {
    if (initialized) return;
    _documentsDirectory ??= (await getApplicationDocumentsDirectory()).path;
    String databasePath = join(_documentsDirectory!, 'beat_app_db.db');
    db = await openDatabase(databasePath);
    initialized = true;
  }

  static void closeDataBaseConnection() {
    if (!initialized) return;
    db!.close();
    initialized = false;
  }

  static Future<List<Map<String, dynamic>>> runQuery(String query) async {
    try {
      await openDataBaseConnection();
      return await db!.rawQuery(query);
    } catch (e) {
      return [];
    }
  }

  static Future<List<WarrantExecType>> _getWarrantExecType() async {
    final data = await runQuery("select * from m_warrant_exec_type;");
    return List<WarrantExecType>.from(
        data.map((e) => WarrantExecType.fromJson(e)));
  }

  static Future<void> _baicDataList() async {
    _allRelationTypesList = RelationType.fetchList(relationTypesMapData);

    _warrantExecTypeList = await _getWarrantExecType();
  }
}
