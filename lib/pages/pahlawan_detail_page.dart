import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pahlawan_app/models/pahlawan.dart';

class PahlawanDetailPage extends StatelessWidget {
  final Pahlawan pahlawan;

  PahlawanDetailPage({required this.pahlawan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pahlawan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _buildImagePreview(pahlawan.imagePath),
            ),
            SizedBox(height: 16),
            Text(
              'Nama: ${pahlawan.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Kategori: ${pahlawan.category}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Deskripsi: ${pahlawan.description}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(String? imagePath) {
    return imagePath != null
        ? Image.file(
            File(imagePath),
            height: 200,
          )
        : SizedBox.shrink(); // If imagePath is empty, return an empty widget
  }
}
