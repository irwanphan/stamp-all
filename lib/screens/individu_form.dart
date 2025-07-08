
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class IndividuFormPage extends StatefulWidget {
  @override
  _IndividuFormPageState createState() => _IndividuFormPageState();
}

class _IndividuFormPageState extends State<IndividuFormPage> {
  final _formKey = GlobalKey<FormState>();
  late Database db;

  final namaController = TextEditingController();
  final umurController = TextEditingController();
  final alamatController = TextEditingController();
  String? _selectedGender;

  Future<String> get _dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, "stamp.db");
  }

  Future<void> initDB() async {
    final path = await _dbPath;
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE individu (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            umur INTEGER,
            gender TEXT,
            alamat TEXT
          )
        ''');
      },
    );
  }

  Future<void> simpanIndividu() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'nama': namaController.text,
      'umur': int.tryParse(umurController.text) ?? 0,
      'gender': _selectedGender,
      'alamat': alamatController.text,
    };

    await db.insert('individu', data);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    initDB();
  }

  @override
  void dispose() {
    namaController.dispose();
    umurController.dispose();
    alamatController.dispose();
    db.close();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
          value == null || value.isEmpty ? 'Wajib diisi' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Data Individu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nama', namaController),
              _buildTextField('Umur', umurController,
                  keyboardType: TextInputType.number),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                items: ['Laki-laki', 'Perempuan']
                    .map((gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Jenis kelamin wajib dipilih' : null,
              ),
              _buildTextField('Alamat', alamatController),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: simpanIndividu,
                child: Text('Simpan Individu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}