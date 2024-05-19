import 'package:flutter/material.dart';
import '../models/pahlawan.dart';
import '../database/pahlawan_database.dart';
import 'pahlawan_detail_page.dart';
import 'add_pahlawan_page.dart';

class PahlawanListPage extends StatefulWidget {
  const PahlawanListPage({Key? key}) : super(key: key);

  @override
  _PahlawanListPageState createState() => _PahlawanListPageState();
}

class _PahlawanListPageState extends State<PahlawanListPage> {
  late Future<List<Pahlawan>> _pahlawanListFuture;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshPahlawanList();
  }

  void _refreshPahlawanList() {
    setState(() {
      _pahlawanListFuture = PahlawanDatabase.instance.getAllPahlawans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pahlawan'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari Pahlawan',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 210, 194, 189),
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pahlawan>>(
              future: _pahlawanListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Pahlawan>? pahlawanList = snapshot.data;
                  if (pahlawanList != null) {
                    List<Pahlawan> filteredPahlawanList = pahlawanList.where((pahlawan) {
                      final query = _searchController.text.toLowerCase();
                      return pahlawan.name.toLowerCase().contains(query) || pahlawan.category.toLowerCase().contains(query);
                    }).toList();
                    return ListView.builder(
                      itemCount: filteredPahlawanList.length,
                      itemBuilder: (context, index) {
                        Pahlawan pahlawan = filteredPahlawanList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.brown.shade700),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Text(
                                pahlawan.name,
                                style: TextStyle(color: Colors.brown.shade700),
                              ),
                              subtitle: Text(
                                pahlawan.category,
                                style: TextStyle(color: Colors.brown.shade700),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PahlawanDetailPage(pahlawan: pahlawan),
                                  ),
                                );
                              },
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text('Edit'),
                                    value: 'edit',
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Delete'),
                                    value: 'delete',
                                  ),
                                ],
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    // Navigate to edit page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPahlawanPage(pahlawanToEdit: pahlawan),
                                      ),
                                    ).then((_) {
                                      // Refresh the list after editing
                                      _refreshPahlawanList();
                                    });
                                  } else if (value == 'delete') {
                                    try {
                                      await PahlawanDatabase.instance.deletePahlawan(pahlawan.id!);
                                      _refreshPahlawanList();
                                    } catch (e) {
                                      print('Error deleting pahlawan: $e');
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Data pahlawan tidak tersedia'));
                  }
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_pahlawan');
        },
        child: const Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 210, 194, 189),
      ),
    );
  }
}
