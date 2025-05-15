// manage_page.dart
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io';
import 'package:path/path.dart';

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
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encryptBytes(dbBytes, iv: iv);

    final output = await getApplicationDocumentsDirectory();
    final backupFile = File(join(output.path, 'backup_stamp.enc'));
    await backupFile.writeAsBytes(encrypted.bytes);

    setState(() => status = "Backup sukses: ${backupFile.path}");
  }

  Future<void> restoreData(String password) async {
    final input = await getApplicationDocumentsDirectory();
    final backupFile = File(join(input.path, 'backup_stamp.enc'));
    if (!await backupFile.exists()) {
      setState(() => status = "File backup tidak ditemukan.");
      return;
    }
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
    setState(() => status = "Restore selesai dari backup.");
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
