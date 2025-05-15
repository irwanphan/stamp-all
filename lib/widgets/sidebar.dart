// sidebar.dart — STAMP Sidebar Custom Style
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  Sidebar({required this.currentIndex, required this.onTap});

  final List<_MenuItem> menuItems = const [
    _MenuItem("Dashboard", Icons.dashboard, 0),
    _MenuItem("Instansi", Icons.apartment, 1),
    _MenuItem("Individu", Icons.account_circle, 2),
    _MenuItem("Timeline", Icons.calendar_today, 3),
    _MenuItem("Bookmarks", Icons.bookmark_border, 4),
    _MenuItem("Pengguna", Icons.groups, 5),
    _MenuItem("Manajemen", Icons.settings, 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF006EBE),
        child: Column(
          children: [
            Container(
              height: 140,
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Image.asset('assets/logo.png', height: 32),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final isSelected = currentIndex == item.index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4),
                    child: Material(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Navigator.pop(context);
                          onTap(item.index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                size: 20,
                                color: isSelected
                                    ? Color(0xFFFF001F)
                                    : Colors.white,
                              ),
                              SizedBox(width: 12),
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: isSelected
                                      ? Color(0xFFFF001F)
                                      : Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final int index;
  const _MenuItem(this.title, this.icon, this.index);
}
