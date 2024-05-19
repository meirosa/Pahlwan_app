import 'package:flutter/material.dart';
import 'package:pahlawan_app/pages/pahlawan_categories_page.dart';
import 'package:pahlawan_app/pages/add_pahlawan_page.dart'; // Import AddPahlawanPage
import 'package:pahlawan_app/pages/pahlawan_list_page.dart'; // Import PahlawanListPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pahlawan App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/pahlawan_categories',
      routes: {
        '/pahlawan_categories': (context) => PahlawanCategoriesPage(),
        '/add_pahlawan': (context) => AddPahlawanPage(), // Add route to AddPahlawanPage
        '/pahlawan_list': (context) => PahlawanListPage(), // Add route to PahlawanListPage
      },
    );
  }
}
