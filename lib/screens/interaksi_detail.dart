import 'package:flutter/material.dart';

class InteraksiDetailPage extends StatelessWidget {
  final Map<String, dynamic> interaksi;

  InteraksiDetailPage({required this.interaksi});

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.label_outline, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(interaksi['nama'] ?? 'Detail Interaksi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 1,
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildDetailRow('Nama Stakeholder', interaksi['nama'] ?? '-'),
                buildDetailRow(
                    'Contact Person', interaksi['contact_person'] ?? '-'),
                buildDetailRow(
                    'Tanggal Interaksi', interaksi['tanggal_interaksi'] ?? '-'),
                buildDetailRow('Status', interaksi['status'] ?? '-'),
                buildDetailRow('Influence', interaksi['influence'] ?? '-'),
                buildDetailRow('Interest', interaksi['interest'] ?? '-'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
