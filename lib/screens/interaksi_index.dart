import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'interaksi_form.dart';
import 'interaksi_detail.dart';

class InteraksiIndexPage extends StatefulWidget {
  @override
  _InteraksiIndexPageState createState() => _InteraksiIndexPageState();
}

class _InteraksiIndexPageState extends State<InteraksiIndexPage> {
  List<Map<String, dynamic>> interaksiList = [];
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
            CREATE TABLE interaksi (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nama TEXT,
              contact_person TEXT,
              tanggal_interaksi TEXT,
              status TEXT,
              influence TEXT,
              interest TEXT
            )
          ''');
        },
      ),
    );
    await loadInteraksi();
  }

  Future<void> loadInteraksi() async {
    if (!db.isOpen) return;
    interaksiList = await db.query('interaksi');
    setState(() {});
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
    if (db.isOpen) db.close();
    super.dispose();
  }

  @override
  flutter.Widget build(flutter.BuildContext flutterContext) {
    return flutter.Padding(
      padding: const flutter.EdgeInsets.all(16.0),
      child: flutter.Column(
        crossAxisAlignment: flutter.CrossAxisAlignment.start,
        children: [
          flutter.Row(
            mainAxisAlignment: flutter.MainAxisAlignment.spaceBetween,
            children: [
              flutter.Text("Daftar Interaksi",
                  style: flutter.Theme.of(flutterContext).textTheme.titleLarge),
              flutter.ElevatedButton(
                onPressed: () {
                  flutter.Navigator.push(
                    flutterContext,
                    flutter.MaterialPageRoute(
                        builder: (_) => InteraksiFormPage()),
                  ).then((_) async {
                    if (db.isOpen) {
                      await loadInteraksi();
                    } else {
                      await initDB();
                    }
                  });
                },
                child: flutter.Text("Input Baru"),
              )
            ],
          ),
          flutter.SizedBox(height: 16),
          flutter.Expanded(
            child: interaksiList.isEmpty
                ? flutter.Center(
                    child: flutter.Text("Belum ada data interaksi."),
                  )
                : flutter.SingleChildScrollView(
                    scrollDirection: flutter.Axis.horizontal,
                    child: flutter.DataTable(
                      columns: const [
                        flutter.DataColumn(label: flutter.Text('Nama')),
                        flutter.DataColumn(
                            label: flutter.Text('Contact Person')),
                        flutter.DataColumn(
                            label: flutter.Text('Tanggal Interaksi')),
                        flutter.DataColumn(label: flutter.Text('Status')),
                        flutter.DataColumn(label: flutter.Text('Influence')),
                        flutter.DataColumn(label: flutter.Text('Interest')),
                        flutter.DataColumn(label: flutter.Text('Aksi')),
                      ],
                      rows: interaksiList.map((item) {
                        return flutter.DataRow(
                          cells: [
                            flutter.DataCell(flutter.Text(item['nama'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['contact_person'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['tanggal_interaksi'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['status'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['influence'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['interest'] ?? '')),
                            flutter.DataCell(
                              flutter.IconButton(
                                icon: const flutter.Icon(
                                  flutter.Icons.remove_red_eye,
                                  color: flutter.Colors.blue,
                                ),
                                onPressed: () {
                                  flutter.Navigator.push(
                                    flutterContext,
                                    flutter.MaterialPageRoute(
                                      builder: (_) => InteraksiDetailPage(
                                        interaksi: item,
                                      ),
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
          ),
        ],
      ),
    );
  }
}
