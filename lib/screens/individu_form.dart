import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class IndividuFormPage extends StatefulWidget {
  @override
  _IndividuFormPageState createState() => _IndividuFormPageState();
}

class _IndividuFormPageState extends State<IndividuFormPage> {
  final _formKey = GlobalKey<FormState>();
  late Database db;

  final Map<String, TextEditingController> controllers = {
    'nama': TextEditingController(),
    'jabatan': TextEditingController(),
    'leveling': TextEditingController(),
    'instansi': TextEditingController(),
    'nama_panggilan': TextEditingController(),
    'tempat_lahir': TextEditingController(),
    'tanggal_lahir': TextEditingController(),
    'no_hp': TextEditingController(),
    'email': TextEditingController(),
    'status': TextEditingController(),
    'alamat': TextEditingController(),
    'agama': TextEditingController(),
    'dapil': TextEditingController(),
    'fraksi': TextEditingController(),
    'hobi': TextEditingController(),
    'folder_foto': TextEditingController(),
    'file_foto': TextEditingController(),
    'jumlah_interaksi': TextEditingController(),
    'tanggal_terakhir_kontak': TextEditingController(),
  };

  String? _selectedGender;

  Future<String> get _dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, "stamp.db");
  }

  Future<void> initDB() async {
    final path = await _dbPath;
    db = await databaseFactory.openDatabase(path);
  }

  Future<void> simpanIndividu() async {
    if (!_formKey.currentState!.validate()) return;

    final data = Map<String, dynamic>.fromEntries(
      controllers.entries.map((e) => MapEntry(e.key, e.value.text)),
    );
    data['jenis_kelamin'] = _selectedGender;
    data['jumlah_interaksi'] =
        int.tryParse(data['jumlah_interaksi'] ?? '') ?? 0;

    await db.insert('individu', data);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    initDB();
  }

  @override
  void dispose() {
    controllers.values.forEach((c) => c.dispose());
    db.close();
    super.dispose();
  }

  Widget _buildTextField(String label, String key,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controllers[key],
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
              _buildTextField('Nama', 'nama'),
              _buildTextField('Jabatan', 'jabatan'),
              _buildTextField('Leveling', 'leveling'),
              _buildTextField('Instansi', 'instansi'),
              _buildTextField('Nama Panggilan', 'nama_panggilan'),
              _buildTextField('Tempat Lahir', 'tempat_lahir'),
              _buildTextField('Tanggal Lahir', 'tanggal_lahir'),
              _buildTextField('No. HP', 'no_hp'),
              _buildTextField('Email', 'email'),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                items: ['Laki-laki', 'Perempuan']
                    .map((gender) =>
                        DropdownMenuItem(value: gender, child: Text(gender)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
                validator: (value) => value == null ? 'Wajib dipilih' : null,
              ),
              _buildTextField('Status', 'status'),
              _buildTextField('Alamat', 'alamat'),
              _buildTextField('Agama', 'agama'),
              _buildTextField('Dapil', 'dapil'),
              _buildTextField('Fraksi', 'fraksi'),
              _buildTextField('Hobi', 'hobi'),
              _buildTextField('Folder Foto', 'folder_foto'),
              _buildTextField('File Foto', 'file_foto'),
              _buildTextField('Jumlah Interaksi', 'jumlah_interaksi',
                  keyboardType: TextInputType.number),
              _buildTextField(
                  'Tanggal Terakhir Kontak', 'tanggal_terakhir_kontak'),
              SizedBox(height: 24),
              ElevatedButton(
                  onPressed: simpanIndividu, child: Text('Simpan Individu')),
            ],
          ),
        ),
      ),
    );
  }
}
