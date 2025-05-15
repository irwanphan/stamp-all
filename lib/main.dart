// main.dart - Entry point untuk STAMP Pertamina

import 'package:flutter/material.dart';
import 'screens/individu_page.dart';
import 'widgets/sidebar.dart';

void main() => runApp(MyApp());

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
  final List<Widget> _pages = [
    IndividuPage(),
    Center(child: Text("Instansi - Coming Soon")),
    Center(child: Text("Manajemen Data - Coming Soon")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("STAMP Dashboard")),
      drawer: Sidebar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
