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
  List<Map<String, dynamic>> individuList = [];

  Future<String> get _dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    return join(dir.path, "stamp.db");
  }

  Future<void> initDB() async {
    final path = await _dbPath;
    db = await databaseFactoryFfi.openDatabase(path);
    await loadStats();
    await loadIndividuList();
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
      final interaksiResult = await db
          .rawQuery('SELECT SUM(jumlah_interaksi) as total FROM individu');
      totalInteraksi = interaksiResult.first['total'] as int? ?? 0;
    } catch (_) {
      totalInteraksi = 0;
    }

    setState(() {});
  }

  Future<void> loadIndividuList() async {
    try {
      individuList = await db.rawQuery('''
        SELECT nama, instansi, jumlah_interaksi
        FROM individu
        ORDER BY jumlah_interaksi DESC
        LIMIT 10
      ''');
    } catch (_) {
      individuList = [];
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

  Widget buildStatCard(String title, int value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800])),
                SizedBox(height: 4),
                Text(value.toString(),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndividuCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Daftar Individu Teratas",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800])),
            Divider(),
            individuList.isEmpty
                ? Center(child: Text("Belum ada data individu."))
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: individuList.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (_, index) {
                      final item = individuList[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(Icons.person, color: Colors.blue),
                        ),
                        title: Text(item['nama'] ?? '-',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(item['instansi'] ?? '-'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 18, color: Colors.grey),
                            SizedBox(width: 4),
                            Text('${item['jumlah_interaksi'] ?? 0}'),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
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
              crossAxisCount: 3,
              childAspectRatio: 3.8,
              mainAxisSpacing: 16,
              physics: NeverScrollableScrollPhysics(),
              children: [
                buildStatCard("Total Instansi", totalInstansi, Icons.apartment,
                    Colors.blue),
                buildStatCard("Total Individu", totalIndividu,
                    Icons.people_alt_outlined, Colors.green),
                buildStatCard("Total Interaksi", totalInteraksi,
                    Icons.connect_without_contact, Colors.deepOrange),
              ],
            ),
            SizedBox(height: 24),
            buildIndividuCard(),
          ],
        ),
      ),
    );
  }
}
