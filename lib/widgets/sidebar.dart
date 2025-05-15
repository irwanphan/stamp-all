// sidebar.dart
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  Sidebar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Text(
              'STAMP Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Individu'),
            selected: currentIndex == 0,
            onTap: () {
              Navigator.pop(context);
              onTap(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Instansi'),
            selected: currentIndex == 1,
            onTap: () {
              Navigator.pop(context);
              onTap(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Manajemen'),
            selected: currentIndex == 2,
            onTap: () {
              Navigator.pop(context);
              onTap(2);
            },
          ),
        ],
      ),
    );
  }
}
