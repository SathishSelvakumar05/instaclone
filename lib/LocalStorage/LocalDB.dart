import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'AlabTech.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const tables = [
      '''
    CREATE TABLE users (
      userId INTEGER PRIMARY KEY AUTOINCREMENT,
      mobileNumber TEXT NOT NULL,
      otp String NOT NULL
    )
    ''',
      '''
    CREATE TABLE post (
      userId INTEGER,
      id INTEGER,
      title String NOT NULL,
      body String NOT NULL
    )
    ''',
    ];

    for (var table in tables) {
      await db.execute(table);
    }
  }
}
