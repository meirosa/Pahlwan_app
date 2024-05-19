import 'dart:io';
import 'package:flutter/material.dart';
import '../models/pahlawan.dart';
import '../database/pahlawan_database.dart';
import 'pahlawan_list_page.dart';
import 'package:image_picker/image_picker.dart';

class AddPahlawanPage extends StatefulWidget {
  final Pahlawan? pahlawanToEdit;

  const AddPahlawanPage({Key? key, this.pahlawanToEdit}) : super(key: key);

  @override
  _AddPahlawanPageState createState() => _AddPahlawanPageState();
}

class _AddPahlawanPageState extends State<AddPahlawanPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? _image;
  String? _selectedCategory;

  List<String> categories = [
    'Pahlawan Perintis Kemerdekaan',
    'Pahlawan Kemerdekaan Nasional',
    'Pahlawan Proklamator',
    'Pahlawan Kebangkitan Nasional',
    'Pahlawan Revolusi',
    'Pahlawan Ampera'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.pahlawanToEdit != null) {
      nameController.text = widget.pahlawanToEdit!.name;
      descriptionController.text = widget.pahlawanToEdit!.description;
      _selectedCategory = widget.pahlawanToEdit!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Biografi'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PahlawanListPage(),
                ),
              );
            },
            icon: Icon(Icons.list),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imagePreview(),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pahlawan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Kategori Pahlawan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Pahlawan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Unggah Gambar',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.image),
                ),
                onTap: _pickImage,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBiography,
                child: const Text(
                  'Simpan Biografi',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 210, 194, 189), // Warna latar belakang coklat
                  elevation: 8, // Mengatur elevasi tombol saat ditekan
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePreview() {
    return Center(
      child: _image == null
          ? const Text('Belum ada gambar dipilih')
          : Image.file(
              _image!,
              height: 100,
            ),
    );
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveBiography() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori pahlawan terlebih dahulu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (nameController.text.isEmpty || descriptionController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi dan gambar harus dipilih!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.pahlawanToEdit != null) {
      // Update existing pahlawan
      Pahlawan updatedPahlawan = Pahlawan(
        id: widget.pahlawanToEdit!.id,
        name: nameController.text,
        category: _selectedCategory!,
        description: descriptionController.text,
        imagePath: _image!.path,
      );

      await PahlawanDatabase.instance.updatePahlawan(updatedPahlawan);
    } else {
      // Add new pahlawan
      Pahlawan newPahlawan = Pahlawan(
        name: nameController.text,
        category: _selectedCategory!,
        description: descriptionController.text,
        imagePath: _image!.path,
      );

      await PahlawanDatabase.instance.insertPahlawan(newPahlawan);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Biografi Pahlawan berhasil ditambahkan!'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PahlawanListPage(),
      ),
    );
  }
}
