// main.dart - Entry point untuk STAMP Pertamina

import 'package:flutter/material.dart';
import 'screens/individu_index.dart';
import 'screens/instansi_index.dart';
import 'screens/manage_page.dart';
import 'widgets/sidebar.dart';
import 'widgets/header_topbar.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Inisialisasi FFI sebelum runApp
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'STAMP Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
      ),
      home: MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  Widget placeholder(String label) => Center(
        child: Text(label,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      );

  final List<Widget> _pages = [
    // index 0 - Dashboard
    Center(child: Text("Dashboard", style: TextStyle(fontSize: 24))),
    // index 1 - Instansi
    InstansiIndexPage(),
    // index 2 - Individu
    IndividuIndexPage(),
    // index 3 - Timeline
    Center(child: Text("Timeline", style: TextStyle(fontSize: 24))),
    // index 4 - Bookmarks
    Center(child: Text("Bookmarks", style: TextStyle(fontSize: 24))),
    // index 5 - Pengguna
    Center(child: Text("Pengguna", style: TextStyle(fontSize: 24))),
    // index 6 - Manajemen
    ManagePage(),
  ];

  final List<String> _pageTitles = [
    "Dashboard",
    "Instansi",
    "Individu",
    "Timeline",
    "Bookmarks",
    "Pengguna",
    "Manajemen",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderTopBar(
        title: _pageTitles[_selectedIndex],
        userName: "Irwan Phan",
        userRole: "Market Analyst",
      ),
      drawer: Sidebar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
