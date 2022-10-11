// ignore_for_file: prefer_single_quotes

import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

Future main() async {
  print("current path" + Platform.resolvedExecutable);
  // Init ffi loader if needed.
  final databaseFactory =
      createDatabaseFactoryFfi(ffiInit: _sqliteWindowsffiInit);

  var db =
      await databaseFactory.openDatabase(r"D:\temp\tempdbases\tmpdbdelete.db",
          options: OpenDatabaseOptions(
              onConfigure: (db) async {
                await db.execute("PRAGMA foreign_keys = ON;");
                await db.execute("SELECT load_extension('mod_spatialite');");
              },
              onOpen: (db) => print("db ${db.path} opened")));
  // await db.execute('''
  // CREATE TABLE Product (
  //     id INTEGER PRIMARY KEY,
  //     title TEXT
  // )
  // ''');
  await db.insert('Product', <String, Object?>{'title': 'Product 1'});
  await db.insert('Product', <String, Object?>{'title': 'Product 1'});

  var result = await db.rawQuery('select * from Product');
  print(result);
  // prints [{id: 1, title: Product 1}, {id: 2, title: Product 1}]
  await db.close();
}

void _sqliteWindowsffiInit() {
  final computedSqlitePath = path
      .join(r"C:\GIT\xportal_mobile\build\windows\runner\Debug\sqlite3.dll");
  print("computed path: $computedSqlitePath");
  open.overrideFor(
      OperatingSystem.windows, () => DynamicLibrary.open(computedSqlitePath));

  // Force an open in the main isolate
  // Loading from an isolate seems to break on windows

  sqlite3.openInMemory().dispose();
}
