// individu_page.dart
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class IndividuPage extends StatefulWidget {
  @override
  _IndividuPageState createState() => _IndividuPageState();
}

class _IndividuPageState extends State<IndividuPage> {
  late Database db;
  List<Map<String, dynamic>> individuList = [];

  final TextEditingController namaController = TextEditingController();
  final TextEditingController instansiController = TextEditingController();
  final TextEditingController jabatanController = TextEditingController();

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
          CREATE TABLE individu (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            instansi TEXT,
            jabatan TEXT
          )
        ''');
      },
    );
    loadIndividu();
  }

  Future<void> loadIndividu() async {
    individuList = await db.query('individu');
    setState(() {});
  }

  Future<void> tambahIndividu() async {
    await db.insert('individu', {
      'nama': namaController.text,
      'instansi': instansiController.text,
      'jabatan': jabatanController.text,
    });
    namaController.clear();
    instansiController.clear();
    jabatanController.clear();
    loadIndividu();
  }

  Future<void> hapusIndividu(int id) async {
    await db.delete('individu', where: 'id = ?', whereArgs: [id]);
    loadIndividu();
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
          Text("Tambah Individu",
              style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          TextField(
            controller: namaController,
            decoration: InputDecoration(labelText: 'Nama'),
          ),
          TextField(
            controller: instansiController,
            decoration: InputDecoration(labelText: 'Instansi'),
          ),
          TextField(
            controller: jabatanController,
            decoration: InputDecoration(labelText: 'Jabatan'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: tambahIndividu,
            child: Text("Simpan Individu"),
          ),
          Divider(height: 32),
          Text("Daftar Individu",
              style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: ListView.builder(
              itemCount: individuList.length,
              itemBuilder: (context, index) {
                final item = individuList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(item['nama']),
                    subtitle: Text("${item['jabatan']} @ ${item['instansi']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => hapusIndividu(item['id']),
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
