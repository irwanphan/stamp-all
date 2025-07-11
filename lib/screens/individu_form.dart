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
  String? _selectedStatus;

  DateTime? _tanggalLahir;
  DateTime? _tanggalTerakhirKontak;

  Future<String> get _dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, "stamp.db");
  }

  Future<void> initDB() async {
    final path = await _dbPath;
    db = await databaseFactoryFfi.openDatabase(path);

    await db.execute('''
      CREATE TABLE IF NOT EXISTS individu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        jabatan TEXT,
        leveling TEXT,
        instansi TEXT,
        nama_panggilan TEXT,
        tempat_lahir TEXT,
        tanggal_lahir TEXT,
        no_hp TEXT,
        email TEXT,
        status TEXT,
        alamat TEXT,
        agama TEXT,
        dapil TEXT,
        fraksi TEXT,
        hobi TEXT,
        folder_foto TEXT,
        file_foto TEXT,
        jumlah_interaksi INTEGER,
        tanggal_terakhir_kontak TEXT,
        jenis_kelamin TEXT
      )
    ''');
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

  Future<void> _selectDate(BuildContext context, String key) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controllers[key]!.text = picked.toIso8601String().split('T').first;
        if (key == 'tanggal_lahir') _tanggalLahir = picked;
        if (key == 'tanggal_terakhir_kontak') _tanggalTerakhirKontak = picked;
      });
    }
  }

  Widget _buildDatePicker(String label, String key) {
    return GestureDetector(
      onTap: () => _selectDate(context, key),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controllers[key],
          decoration: InputDecoration(labelText: label),
          validator: (value) =>
              value == null || value.isEmpty ? 'Wajib diisi' : null,
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Data Individu/Stakeholder')),
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
              _buildDatePicker('Tanggal Lahir', 'tanggal_lahir'),
              _buildTextField('No. HP', 'no_hp',
                  keyboardType: TextInputType.number),
              TextFormField(
                controller: controllers['email'],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  return emailRegex.hasMatch(value)
                      ? null
                      : 'Email tidak valid';
                },
              ),
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
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['Menikah', 'Belum Menikah']
                    .map((status) =>
                        DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedStatus = val;
                    controllers['status']!.text = val!;
                  });
                },
                validator: (value) => value == null ? 'Wajib dipilih' : null,
              ),
              _buildTextField('Alamat', 'alamat'),
              _buildTextField('Agama', 'agama'),
              _buildTextField('Dapil', 'dapil'),
              _buildTextField('Fraksi', 'fraksi'),
              _buildTextField('Hobi', 'hobi'),
              _buildTextField('Folder Foto', 'folder_foto'),
              _buildTextField('File Foto', 'file_foto'),
              _buildTextField('Jumlah Interaksi', 'jumlah_interaksi',
                  keyboardType: TextInputType.number),
              _buildDatePicker(
                  'Tanggal Terakhir Kontak', 'tanggal_terakhir_kontak'),
              SizedBox(height: 24),
              ElevatedButton(
                  onPressed: simpanIndividu, child: Text('Simpan Individu/Stakeholder')),
            ],
          ),
        ),
      ),
    );
  }
}
