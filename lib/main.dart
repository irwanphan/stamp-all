// main.dart - Entry point untuk STAMP Pertamina

import 'package:flutter/material.dart';
import 'screens/individu_page.dart';
import 'screens/instansi_page.dart';
import 'screens/manage_page.dart';
import 'widgets/sidebar.dart';
import 'widgets/header_topbar.dart';

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
    InstansiPage(),
    ManagePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderTopBar(
        title: "Instansi",
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
