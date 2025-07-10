import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'instansi_form.dart';
import 'instansi_detail.dart';

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
    db = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
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
      ),
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
    sqfliteFfiInit(); // Penting!
    databaseFactory = databaseFactoryFfi;
    initDB();
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
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
                    MaterialPageRoute(builder: (_) => InstansiFormPage()),
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
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Lokasi')),
                        DataColumn(label: Text('Aksi')),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          InstansiDetailPage(instansi: item),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
