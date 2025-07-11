import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Database db;
  int totalInstansi = 0;
  int totalIndividu = 0;
  int totalInteraksi = 0;
  int stakeholderAktif = 0;

  int highHigh = 0;
  int highLow = 0;
  int lowHigh = 0;
  int lowLow = 0;

  Future<String> get _dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    return join(dir.path, "stamp.db");
  }

  Future<void> initDB() async {
    final path = await _dbPath;
    db = await databaseFactoryFfi.openDatabase(path);
    await loadStats();
    await loadStakeholderMatrix();
  }

  Future<void> loadStats() async {
    try {
      final instansiResult =
          await db.rawQuery('SELECT COUNT(*) as count FROM instansi');
      totalInstansi = instansiResult.first['count'] as int? ?? 0;
    } catch (_) {
      totalInstansi = 0;
    }

    try {
      final individuResult =
          await db.rawQuery('SELECT COUNT(*) as count FROM individu');
      totalIndividu = individuResult.first['count'] as int? ?? 0;
    } catch (_) {
      totalIndividu = 0;
    }

    try {
      final interaksiResult =
          await db.rawQuery('SELECT COUNT(*) as total FROM interaksi');
      totalInteraksi = interaksiResult.first['total'] as int? ?? 0;
    } catch (_) {
      totalInteraksi = 0;
    }

    try {
      final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
      final formattedDate = thirtyDaysAgo.toIso8601String().split('T').first;

      final aktifResult = await db.rawQuery('''
        SELECT COUNT(*) as count
        FROM individu
        WHERE tanggal_terakhir_kontak IS NOT NULL
          AND DATE(tanggal_terakhir_kontak) >= ?
      ''', [formattedDate]);

      stakeholderAktif = aktifResult.first['count'] as int? ?? 0;
    } catch (_) {
      stakeholderAktif = 0;
    }

    setState(() {});
  }

  Future<void> loadStakeholderMatrix() async {
    try {
      final result = await db.rawQuery('''
        SELECT interest, influence, COUNT(*) as count
        FROM interaksi
        WHERE interest IN ('High', 'Low')
          AND influence IN ('High', 'Low')
        GROUP BY interest, influence
      ''');

      // Reset dulu
      highHigh = 0;
      highLow = 0;
      lowHigh = 0;
      lowLow = 0;

      for (final row in result) {
        final interest = row['interest'];
        final influence = row['influence'];
        final count = row['count'] as int;

        if (interest == 'High' && influence == 'High') {
          highHigh = count;
        } else if (interest == 'High' && influence == 'Low') {
          highLow = count;
        } else if (interest == 'Low' && influence == 'High') {
          lowHigh = count;
        } else if (interest == 'Low' && influence == 'Low') {
          lowLow = count;
        }
      }
    } catch (_) {
      highHigh = 0;
      highLow = 0;
      lowHigh = 0;
      lowLow = 0;
    }

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

  Widget buildStatCard(
    String title,
    int value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  if (subtitle != null) ...[
                    SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54)),
                  ],
                  SizedBox(height: 8),
                  Text(value.toString(),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMatrixBox(String label, int count, Color color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: ListTile(
          title: Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            count.toString(),
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildStakeholderMatrixCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("StakeHolder Management",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildMatrixBox(
                  "High Interest\nLow Influence", highLow, Colors.lightBlue),
            ),
            SizedBox(width: 16),
            Expanded(
              child: buildMatrixBox("High Interest\nHigh Influence", highHigh,
                  Colors.blue.shade800),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildMatrixBox(
                  "Low Interest\nLow Influence", lowLow, Colors.redAccent),
            ),
            SizedBox(width: 16),
            Expanded(
              child: buildMatrixBox(
                  "Low Interest\nHigh Influence", lowHigh, Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3.8,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              physics: NeverScrollableScrollPhysics(),
              children: [
                buildStatCard(
                  "Total StakeHolders",
                  totalIndividu,
                  Icons.people_alt_outlined,
                  Colors.green,
                  subtitle: "Jumlah Individu yang berinteraksi",
                ),
                buildStatCard(
                  "Total Instansi",
                  totalInstansi,
                  Icons.apartment,
                  Colors.blue,
                  subtitle: "Jumlah instansi yang aktif dan non-aktif",
                ),
                buildStatCard(
                  "Total Interactions",
                  totalInteraksi,
                  Icons.connect_without_contact,
                  Colors.deepOrange,
                  subtitle: "Jumlah interaksi dengan stakeholder",
                ),
                buildStatCard(
                  "Stakeholder aktif",
                  stakeholderAktif,
                  Icons.timeline_outlined,
                  Colors.purple,
                  subtitle:
                      "Interaksi terjadi dalam kurun waktu 30 hari terakhir",
                ),
              ],
            ),
            SizedBox(height: 24),
            buildStakeholderMatrixCard(),
          ],
        ),
      ),
    );
  }
}
