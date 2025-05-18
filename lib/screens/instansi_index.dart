// instansi_index.dart - Menampilkan data dari SQLite dalam bentuk tabel dengan tombol detail
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'instansi_form.dart';

class InstansiIndexPage extends StatefulWidget {
  @override
  _InstansiIndexPageState createState() => _InstansiIndexPageState();
}

class _InstansiIndexPageState extends State<InstansiIndexPage> {
  List<Map<String, dynamic>> instansiList = [];
  late Database db;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Daftar Instansi",
                  style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InstansiFormPage()),
                  ).then((_) => loadInstansi());
                },
                child: Text("Input Baru"),
              )
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: instansiList.isEmpty
                ? Center(child: Text("Belum ada data instansi."))
                : DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Lokasi')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: instansiList.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item['nama'] ?? '')),
                          DataCell(Text(item['lokasi'] ?? '')),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.remove_red_eye_outlined,
                                  color: Colors.blue),
                              onPressed: () {
                                // Tampilkan halaman detail instansi jika sudah tersedia
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }
}
