// instansi_index.dart
import 'package:flutter/material.dart';
import 'instansi_form.dart';

class InstansiIndexPage extends StatelessWidget {
  final List<Map<String, dynamic>> dummyInstansi = [
    {
      'nama': 'The X Corp',
      'status': 'High Interest',
      'tanggal': 'Apr 20, 2025',
      'aktif': true
    },
    {
      'nama': 'Datascale AI Corp',
      'status': 'High Interest',
      'tanggal': 'Apr 20, 2025',
      'aktif': true
    },
    {
      'nama': 'Media Channel Corp',
      'status': 'High Interest',
      'tanggal': 'Apr 13, 2025',
      'aktif': true
    },
    {
      'nama': 'Networking Corp',
      'status': 'Prospect',
      'tanggal': 'Mar 20, 2025',
      'aktif': true
    },
    {
      'nama': 'Doel People',
      'status': 'Inaktif',
      'tanggal': 'Mar 15, 2025',
      'aktif': false
    },
  ];

  Color getBadgeColor(String status) {
    switch (status) {
      case 'High Interest':
        return Colors.green.shade100;
      case 'Prospect':
        return Colors.orange.shade100;
      case 'Inaktif':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
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
                  );
                },
                child: Text("Input Baru"),
              )
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Nama")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Tanggal Input")),
                  DataColumn(label: Text("Aktif")),
                  DataColumn(label: Text("Action")),
                ],
                rows: dummyInstansi.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data['nama'])),
                    DataCell(Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getBadgeColor(data['status']),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Text(data['status'], style: TextStyle(fontSize: 12)),
                    )),
                    DataCell(Text(data['tanggal'])),
                    DataCell(Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: data['aktif']
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(data['aktif'] ? 'Aktif' : 'Inaktif'),
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(icon: Icon(Icons.search), onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {}),
                        IconButton(icon: Icon(Icons.delete), onPressed: () {}),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
