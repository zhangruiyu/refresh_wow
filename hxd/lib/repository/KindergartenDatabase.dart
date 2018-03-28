import 'dart:async';
import 'dart:io';

import 'package:hxd/repository/UserModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class KindergartenDatabase {
  static openKindergartenDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");
    Database db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
// When creating the db, create the table
      await db.execute(userTableSql);
    });
    return db;
  }
}
