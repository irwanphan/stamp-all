import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import '../helper.dart';

class InstansiFormPage extends StatefulWidget {
  @override
  _InstansiFormPageState createState() => _InstansiFormPageState();
}

class _InstansiFormPageState extends State<InstansiFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  Future<String> get _dbPath async {
    final databasesPath = await getDatabasesPath();
    return join(databasesPath, 'stamp.db');
  }

  Future<void> _simpanInstansi(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final db = await openDatabase(await _dbPath);
      await db.insert('instansi', {
        'nama': _namaController.text,
        'lokasi': _lokasiController.text,
        'status': 'High Interest',
        'aktif': 1,
        'tanggal': DateTime.now().toIso8601String(),
      });
      await db.close();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Instansi'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Instansi'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lokasiController,
                decoration: InputDecoration(labelText: 'Lokasi'),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _simpanInstansi(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                ),
                child: Text('Simpan Instansi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
