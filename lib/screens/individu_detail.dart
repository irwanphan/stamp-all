import 'dart:io';
import 'package:flutter/material.dart';

class IndividuDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  IndividuDetailPage({required this.data});

  Widget _buildInfoTile(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 2),
        Text(value?.isNotEmpty == true ? value! : '-',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileFoto = data['file_foto'];
    final nama = data['nama'] ?? '';
    final jabatan = data['jabatan'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Individu"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      fileFoto != null && fileFoto.toString().isNotEmpty
                          ? FileImage(File(fileFoto))
                          : AssetImage('assets/default_profile.png')
                              as ImageProvider,
                ),
                SizedBox(height: 12),
                Text(nama,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                if (jabatan.isNotEmpty)
                  Text(jabatan, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          SizedBox(height: 24),
          Divider(thickness: 1),
          Text("Informasi Kontak",
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12),
          _buildInfoTile("Email", data['email']),
          _buildInfoTile("No. HP", data['no_hp']),
          _buildInfoTile("Jenis Kelamin", data['jenis_kelamin']),
          _buildInfoTile("Status", data['status']),
          _buildInfoTile(
              "Jumlah Interaksi", data['jumlah_interaksi']?.toString()),
          _buildInfoTile(
              "Tanggal Terakhir Kontak", data['tanggal_terakhir_kontak']),
          Divider(thickness: 1),
          Text("Informasi Tambahan",
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12),
          _buildInfoTile("Instansi", data['instansi']),
          _buildInfoTile("Fraksi", data['fraksi']),
          _buildInfoTile("Dapil", data['dapil']),
          _buildInfoTile("Agama", data['agama']),
          _buildInfoTile("Leveling", data['leveling']),
          _buildInfoTile("Hobi", data['hobi']),
          _buildInfoTile("Nama Panggilan", data['nama_panggilan']),
          _buildInfoTile("Tempat Lahir", data['tempat_lahir']),
          _buildInfoTile("Tanggal Lahir", data['tanggal_lahir']),
          Divider(thickness: 1),
          Text("Alamat", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          Text(data['alamat'] ?? '-', style: TextStyle(fontSize: 14)),
          SizedBox(height: 16),
          Text("Folder Foto", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          Text(data['folder_foto'] ?? '-', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
