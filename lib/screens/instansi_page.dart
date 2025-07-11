import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InstansiPage extends StatefulWidget {
  @override
  _InstansiPageState createState() => _InstansiPageState();
}

class _InstansiPageState extends State<InstansiPage> {
  late Database db;
  List<Map<String, dynamic>> instansiList = [];

  final TextEditingController namaController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  Future<String> get _dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    return join(dir.path, "stamp.db");
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
            lokasi TEXT
          )
        ''');
      },
    );
    loadInstansi();
  }

  Future<void> loadInstansi() async {
    instansiList = await db.query('instansi');
    setState(() {});
  }

  Future<void> tambahInstansi() async {
    await db.insert('instansi', {
      'nama': namaController.text,
      'lokasi': lokasiController.text,
    });
    namaController.clear();
    lokasiController.clear();
    loadInstansi();
  }

  Future<void> hapusInstansi(int id) async {
    await db.delete('instansi', where: 'id = ?', whereArgs: [id]);
    loadInstansi();
  }

  @override
  void initState() {
    super.initState();
    initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tambah Instansi",
              style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          TextField(
            controller: namaController,
            decoration: InputDecoration(labelText: 'Nama Instansi'),
          ),
          TextField(
            controller: lokasiController,
            decoration: InputDecoration(labelText: 'Lokasi'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: tambahInstansi,
            child: Text("Simpan Instansi"),
          ),
          Divider(height: 32),
          Text("Daftar Instansi",
              style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: ListView.builder(
              itemCount: instansiList.length,
              itemBuilder: (context, index) {
                final item = instansiList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(item['nama']),
                    subtitle: Text("Lokasi: ${item['lokasi']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => hapusInstansi(item['id']),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
