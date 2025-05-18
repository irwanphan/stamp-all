// instansi_detail.dart
import 'dart:io';
import 'package:flutter/material.dart';

class InstansiDetailPage extends StatelessWidget {
  final Map<String, dynamic> instansi;

  InstansiDetailPage({required this.instansi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(instansi['nama'] ?? 'Detail Instansi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (instansi['foto'] != null && instansi['foto'].isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(instansi['foto']),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 16),
          Text(instansi['nama'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Kategori: ${instansi['kategori'] ?? ''}"),
          Text("PIC: ${instansi['pic'] ?? ''}"),
          Text("Kontak: ${instansi['kontak'] ?? ''}"),
          Text("Email: ${instansi['email'] ?? ''}"),
          Text("Website: ${instansi['website'] ?? ''}"),
          SizedBox(height: 8),
          Text("Koordinat: ${instansi['koordinat'] ?? '-'}"),
          SizedBox(height: 16),
          Text("Alamat / Lokasi:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(instansi['lokasi'] ?? ''),
          SizedBox(height: 16),
          Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(instansi['deskripsi'] ?? ''),
        ],
      ),
    );
  }
}
