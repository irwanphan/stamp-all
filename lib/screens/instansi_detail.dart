import 'dart:io';
import 'package:flutter/material.dart';

class InstansiDetailPage extends StatelessWidget {
  final Map<String, dynamic> instansi;

  InstansiDetailPage({required this.instansi});

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
    final imagePath = instansi['foto'];

    return Scaffold(
      appBar: AppBar(
        title: Text(instansi['nama'] ?? 'Detail Instansi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null &&
                imagePath.isNotEmpty &&
                File(imagePath).existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16),
            Text(
              instansi['nama'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 1,
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildDetailRow('Kategori', instansi['kategori'] ?? '-'),
                    buildDetailRow('PIC', instansi['pic'] ?? '-'),
                    buildDetailRow('Kontak', instansi['kontak'] ?? '-'),
                    buildDetailRow('Email', instansi['email'] ?? '-'),
                    buildDetailRow('Website', instansi['website'] ?? '-'),
                    buildDetailRow('Koordinat', instansi['koordinat'] ?? '-'),
                    buildDetailRow('Lokasi', instansi['lokasi'] ?? '-'),
                  ],
                ),
              ),
            ),
            Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(instansi['deskripsi'] ?? '-',
                style: TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
