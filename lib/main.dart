// Flutter project starter for STAMP Pertamina Offline Dashboard
// Includes: SQLite DB, basic navigation, encrypted backup/restore

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STAMP Dashboard',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String status = "";

  Future<String> get _dbPath async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, "stamp.db");
  }

  Future<void> initDB() async {
    final path = await _dbPath;
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE individu (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama TEXT,
          instansi TEXT,
          jabatan TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE instansi (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama TEXT,
          lokasi TEXT
        )
        ''');
      },
    );
    setState(() => status = "Database Initialized at $path");
  }

  Future<void> backupData(String password) async {
    final path = await _dbPath;
    final file = File(path);
    final dbBytes = await file.readAsBytes();

    final key = encrypt.Key.fromUtf8(password.padRight(32, '0'));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encryptBytes(dbBytes, iv: iv);

    final output = await getApplicationDocumentsDirectory();
    final backupFile = File(join(output.path, 'backup_stamp.enc'));
    await backupFile.writeAsBytes(encrypted.bytes);

    setState(() => status = "Backup done: ${backupFile.path}");
  }

  Future<void> restoreData(String password) async {
    final input = await getApplicationDocumentsDirectory();
    final backupFile = File(join(input.path, 'backup_stamp.enc'));
    final encBytes = await backupFile.readAsBytes();

    final key = encrypt.Key.fromUtf8(password.padRight(32, '0'));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(encBytes),
      iv: iv,
    );

    final path = await _dbPath;
    await File(path).writeAsBytes(decrypted);
    setState(() => status = "Restore complete.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("STAMP Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: initDB,
              child: Text("Inisialisasi Database"),
            ),
            ElevatedButton(
              onPressed: () => backupData("pertamina_secure"),
              child: Text("Backup terenkripsi"),
            ),
            ElevatedButton(
              onPressed: () => restoreData("pertamina_secure"),
              child: Text("Restore terenkripsi"),
            ),
            SizedBox(height: 20),
            Text(status, style: TextStyle(color: Colors.grey[700]))
          ],
        ),
      ),
    );
  }
}
