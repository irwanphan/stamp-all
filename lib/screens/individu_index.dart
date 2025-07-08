individu index dart

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'individu_form.dart';

class IndividuIndexPage extends StatefulWidget {
  @override
  _IndividuIndexPageState createState() => _IndividuIndexPageState();
}

class _IndividuIndexPageState extends State<IndividuIndexPage> {
  List<Map<String, dynamic>> individuList = [];
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
    loadIndividu();
  }

  Future<void> loadIndividu() async {
    individuList = await db.query('individu');
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Daftar Individu",
                    style: Theme.of(context).textTheme.titleLarge),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IndividuFormPage()),
                    ).then((_) => loadIndividu());
                  },
                  child: Text("Input Baru"),
                )
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: individuList.isEmpty
                  ? Center(child: Text("Belum ada data individu."))
                  : DataTable(
                      columns: [
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Umur')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: individuList.map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item['nama'] ?? '')),
                          DataCell(Text(item['umur']?.toString() ?? '')),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.remove_red_eye_outlined,
                                  color: Colors.blue),
                              onPressed: () {
                                // Navigasi ke halaman detail
                                // Navigator.push(...);
                              },
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
