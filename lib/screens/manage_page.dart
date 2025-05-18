// manage_page.dart
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';
import '../helper.dart';

class ManagePage extends StatefulWidget {
  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  String status = "";

  Future<String> get _dbPath async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, "stamp.db");
  }

  Future<void> backupData(String password) async {
    final path = await _dbPath;
    final file = File(path);
    if (!await file.exists()) {
      setState(() => status = "Database tidak ditemukan.");
      return;
    }

    final dbBytes = await file.readAsBytes();
    final key = encrypt.Key.fromUtf8(password.padRight(32, '0'));
    final iv = encrypt.IV.fromSecureRandom(16); // generate IV
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encryptBytes(dbBytes, iv: iv);

    final result = await FilePicker.platform.getDirectoryPath();
    if (result == null) {
      setState(() => status = "Backup dibatalkan.");
      return;
    }

    final backupFile = File(join(result, 'backup_stamp.enc'));

    // Simpan IV (16 byte) + encrypted data
    await backupFile.writeAsBytes(iv.bytes + encrypted.bytes);

    setState(() => status = "Backup sukses di folder:\n${backupFile.path}");
  }

  Future<void> restoreData(String password) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['enc'],
    );

    if (result == null || result.files.single.path == null) {
      setState(() => status = "Restore dibatalkan.");
      return;
    }

    final backupPath = result.files.single.path!;
    final backupBytes = await File(backupPath).readAsBytes();

    try {
      final key = encrypt.Key.fromUtf8(password.padRight(32, '0'));

      // Pisahkan IV (first 16 byte) dan encrypted data
      final iv = encrypt.IV(backupBytes.sublist(0, 16));
      final encryptedData = backupBytes.sublist(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decryptBytes(
        encrypt.Encrypted(encryptedData),
        iv: iv,
      );

      final path = await _dbPath;
      await File(path).writeAsBytes(decrypted);
      setState(() => status = "Restore berhasil dari file:\n$backupPath");
    } catch (e) {
      setState(() => status = "Gagal restore: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Manajemen Data", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.backup),
            label: Text("Backup terenkripsi"),
            onPressed: () => backupData("pertamina_secure"),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            icon: Icon(Icons.restore),
            label: Text("Restore dari backup"),
            onPressed: () => restoreData("pertamina_secure"),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            icon: Icon(Icons.bug_report),
            label: Text("Isi Dummy Data"),
            onPressed: () async {
              final dbPath = await _dbPath;
              final db = await openDatabase(dbPath);
              await insertDummyData(db);
              await db.close();
              setState(() => status = "Dummy data berhasil dimasukkan.");
            },
          ),
          SizedBox(height: 24),
          Divider(),
          Text("Status:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(status, style: TextStyle(color: Colors.grey[700]))
        ],
      ),
    );
  }
}
