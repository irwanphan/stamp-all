import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'individu_form.dart';
import 'individu_detail.dart';

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
    db = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE individu (
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
              jenis_kelamin TEXT,
              status TEXT,
              alamat TEXT,
              agama TEXT,
              dapil TEXT,
              fraksi TEXT,
              hobi TEXT,
              folder_foto TEXT,
              file_foto TEXT,
              jumlah_interaksi INTEGER,
              tanggal_terakhir_kontak TEXT
            )
          ''');
        },
      ),
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
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    initDB();
  }

  @override
  void dispose() {
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
              flutter.Text("Daftar Individu",
                  style: flutter.Theme.of(flutterContext).textTheme.titleLarge),
              flutter.ElevatedButton(
                onPressed: () {
                  flutter.Navigator.push(
                    flutterContext,
                    flutter.MaterialPageRoute(
                        builder: (_) => IndividuFormPage()),
                  ).then((_) => loadIndividu());
                },
                child: flutter.Text("Input Baru"),
              )
            ],
          ),
          flutter.SizedBox(height: 16),
          flutter.Expanded(
            child: individuList.isEmpty
                ? flutter.Center(
                    child: flutter.Text("Belum ada data individu."))
                : flutter.SingleChildScrollView(
                    scrollDirection: flutter.Axis.horizontal,
                    child: flutter.DataTable(
                      columns: const [
                        flutter.DataColumn(label: flutter.Text('Nama')),
                        flutter.DataColumn(label: flutter.Text('Jabatan')),
                        flutter.DataColumn(label: flutter.Text('Leveling')),
                        flutter.DataColumn(label: flutter.Text('Instansi')),
                        flutter.DataColumn(label: flutter.Text('Panggilan')),
                        flutter.DataColumn(label: flutter.Text('Tempat Lahir')),
                        flutter.DataColumn(label: flutter.Text('Tgl Lahir')),
                        flutter.DataColumn(label: flutter.Text('No. HP')),
                        flutter.DataColumn(label: flutter.Text('Email')),
                        flutter.DataColumn(label: flutter.Text('Kelamin')),
                        flutter.DataColumn(label: flutter.Text('Status')),
                        flutter.DataColumn(label: flutter.Text('Alamat')),
                        flutter.DataColumn(label: flutter.Text('Agama')),
                        flutter.DataColumn(label: flutter.Text('Dapil')),
                        flutter.DataColumn(label: flutter.Text('Fraksi')),
                        flutter.DataColumn(label: flutter.Text('Hobi')),
                        flutter.DataColumn(label: flutter.Text('Interaksi')),
                        flutter.DataColumn(label: flutter.Text('Tgl Kontak')),
                        flutter.DataColumn(label: flutter.Text('Aksi')),
                      ],
                      rows: individuList.map((item) {
                        return flutter.DataRow(
                          cells: [
                            flutter.DataCell(flutter.Text(item['nama'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['jabatan'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['leveling'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['instansi'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['nama_panggilan'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['tempat_lahir'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['tanggal_lahir'] ?? '')),
                            flutter.DataCell(flutter.Text(item['no_hp'] ?? '')),
                            flutter.DataCell(flutter.Text(item['email'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['jenis_kelamin'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['status'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['alamat'] ?? '')),
                            flutter.DataCell(flutter.Text(item['agama'] ?? '')),
                            flutter.DataCell(flutter.Text(item['dapil'] ?? '')),
                            flutter.DataCell(
                                flutter.Text(item['fraksi'] ?? '')),
                            flutter.DataCell(flutter.Text(item['hobi'] ?? '')),
                            flutter.DataCell(flutter.Text(
                                '${item['jumlah_interaksi'] ?? 0}')),
                            flutter.DataCell(flutter.Text(
                                item['tanggal_terakhir_kontak'] ?? '')),
                            flutter.DataCell(
                              flutter.IconButton(
                                icon: const flutter.Icon(
                                    flutter.Icons.remove_red_eye,
                                    color: flutter.Colors.blue),
                                onPressed: () {
                                  flutter.Navigator.push(
                                    flutterContext,
                                    flutter.MaterialPageRoute(
                                      builder: (_) =>
                                          IndividuDetailPage(data: item),
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
