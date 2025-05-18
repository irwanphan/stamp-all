// instansi_form.dart - Formulir untuk input data instansi lengkap
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class InstansiFormPage extends StatefulWidget {
  @override
  _InstansiFormPageState createState() => _InstansiFormPageState();
}

class _InstansiFormPageState extends State<InstansiFormPage> {
  final _formKey = GlobalKey<FormState>();
  late Database db;

  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final kategoriController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final kontakController = TextEditingController();
  final picController = TextEditingController();
  final deskripsiController = TextEditingController();
  final koordinatController = TextEditingController();

  File? _foto;

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
          CREATE TABLE instansi (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            lokasi TEXT,
            kategori TEXT,
            email TEXT,
            website TEXT,
            kontak TEXT,
            pic TEXT,
            deskripsi TEXT,
            foto TEXT,
            koordinat TEXT
          )
        ''');
      },
    );
  }

  Future<void> simpanInstansi() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'nama': namaController.text,
      'lokasi': lokasiController.text,
      'kategori': kategoriController.text,
      'email': emailController.text,
      'website': websiteController.text,
      'kontak': kontakController.text,
      'pic': picController.text,
      'deskripsi': deskripsiController.text,
      'koordinat': koordinatController.text,
      'foto': _foto?.path ?? '',
    };

    await db.insert('instansi', data);
    Navigator.pop(context);
  }

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     setState(() => _foto = File(picked.path));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    initDB();
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
          value == null || value.isEmpty ? 'Wajib diisi' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Data Instansi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nama Instansi', namaController),
              _buildTextField('Kategori Instansi', kategoriController),
              _buildTextField('Email', emailController),
              _buildTextField('Website', websiteController),
              _buildTextField('Kontak', kontakController),
              _buildTextField('PIC', picController),
              _buildTextField('Lokasi', lokasiController),
              _buildTextField('Koordinat', koordinatController),
              TextFormField(
                controller: deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  // ElevatedButton(
                  //   onPressed: _pickImage,
                  //   child: Text("Pilih Foto"),
                  // ),
                  SizedBox(width: 10),
                  if (_foto != null) Text(p.basename(_foto!.path)),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: simpanInstansi,
                child: Text('Simpan Instansi'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
