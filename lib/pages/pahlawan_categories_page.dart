import 'package:flutter/material.dart';
import 'package:pahlawan_app/pages/add_pahlawan_page.dart'; 
import '../database/pahlawan_database.dart'; 

class PahlawanCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BIOGRAFI PAHLAWAN'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20), // Menambahkan jarak atas
          Text(
            'BIOGRAFI PAHLAWAN', // Teks ditengah atas
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24, // Ukuran font yang lebih besar
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20), // Menambahkan jarak
          Center(
            child: Image.asset(
              'assets/icon.jpg', // Tambahkan gambar di sini
              width: 400, // Lebar gambar
            ),
          ),
          SizedBox(height: 20), // Menambahkan jarak
          ElevatedButton(
            onPressed: () async {
              // Navigate to the AddPahlawanPage when the button is pressed
              // and wait for the result
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPahlawanPage()),
              );

              // Check if result is not null and insert the pahlawan into the database
              if (result != null) {
                await PahlawanDatabase.instance.insertPahlawan(result);
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 210, 194, 189), // Warna latar belakang coklat
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Text(
                'Tambah Biografi Baru',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black, // Warna teks hitam
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}