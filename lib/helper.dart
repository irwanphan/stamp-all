// helper.dart — untuk masukkan dummy data uji backup/restore
import 'package:sqflite/sqflite.dart';

Future<void> insertDummyData(Database db) async {
  final instansiDummy = [
    {'nama': 'PT Pertamina Hulu', 'lokasi': 'Jakarta'},
    {'nama': 'PT Kilang Pertamina Internasional', 'lokasi': 'Balikpapan'},
    {'nama': 'PT Pertamina Patra Niaga', 'lokasi': 'Surabaya'},
  ];

  final individuDummy = [
    {
      'nama': 'Ahmad Ramadhan',
      'instansi': 'PT Pertamina Hulu',
      'jabatan': 'Manager Operasional'
    },
    {
      'nama': 'Sinta Dewi',
      'instansi': 'PT Kilang Pertamina Internasional',
      'jabatan': 'Supervisor HSE'
    },
    {
      'nama': 'Budi Santosa',
      'instansi': 'PT Pertamina Patra Niaga',
      'jabatan': 'Direktur Logistik'
    },
  ];

  for (final item in instansiDummy) {
    await db.insert('instansi', item);
  }
  for (final item in individuDummy) {
    await db.insert('individu', item);
  }
}
