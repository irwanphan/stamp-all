import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class InteraksiFormPage extends StatefulWidget {
  @override
  _InteraksiFormPageState createState() => _InteraksiFormPageState();
}

class _InteraksiFormPageState extends State<InteraksiFormPage> {
  final _formKey = GlobalKey<FormState>();
  late Database db;

  final Map<String, TextEditingController> controllers = {
    'nama': TextEditingController(),
    'contact_person': TextEditingController(),
    'tanggal_interaksi': TextEditingController(),
  };

  String? selectedStatus;
  String? selectedInfluence;
  String? selectedInterest;

  Future<String> get _dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, "stamp.db");
  }

  Future<void> initDB() async {
    final path = await _dbPath;
    db = await databaseFactoryFfi.openDatabase(path);

    await db.execute('''
      CREATE TABLE IF NOT EXISTS interaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        contact_person TEXT,
        tanggal_interaksi TEXT,
        status TEXT,
        influence TEXT,
        interest TEXT
      )
    ''');
  }

  Future<void> simpanInteraksi() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'nama': controllers['nama']!.text,
      'contact_person': controllers['contact_person']!.text,
      'tanggal_interaksi': controllers['tanggal_interaksi']!.text,
      'status': selectedStatus,
      'influence': selectedInfluence,
      'interest': selectedInterest,
    };

    await db.insert('interaksi', data);
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controllers['tanggal_interaksi']!.text =
            picked.toIso8601String().split('T').first;
      });
    }
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

  Widget _buildDatePicker(String label, String key) {
    return GestureDetector(
      onTap: () => _selectDate(context),
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
      appBar: AppBar(title: Text('Tambah Interaksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nama Stakeholder', 'nama'),
              _buildTextField('Contact Person', 'contact_person'),
              _buildDatePicker('Tanggal Interaksi', 'tanggal_interaksi'),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['Completed', 'Delayed', 'At risk', 'On going']
                    .map((status) =>
                        DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (val) => setState(() => selectedStatus = val),
                validator: (value) => value == null ? 'Wajib dipilih' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedInfluence,
                decoration: InputDecoration(labelText: 'Influence'),
                items: ['High', 'Medium', 'Low']
                    .map(
                        (val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) => setState(() => selectedInfluence = val),
                validator: (value) => value == null ? 'Wajib dipilih' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedInterest,
                decoration: InputDecoration(labelText: 'Interest'),
                items: ['High', 'Medium', 'Low']
                    .map(
                        (val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) => setState(() => selectedInterest = val),
                validator: (value) => value == null ? 'Wajib dipilih' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                  onPressed: simpanInteraksi, child: Text('Simpan Interaksi')),
            ],
          ),
        ),
      ),
    );
  }
}
