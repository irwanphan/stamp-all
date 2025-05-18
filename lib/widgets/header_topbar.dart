// header_topbar.dart
import 'package:flutter/material.dart';

class HeaderTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String userName;
  final String userRole;
  final bool showMenuButton;

  HeaderTopBar({
    required this.title,
    required this.userName,
    required this.userRole,
    this.showMenuButton = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: showMenuButton
          ? IconButton(
              icon: Icon(Icons.menu, color: Colors.black87),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            )
          : null,
      title: Text(title,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(userRole,
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              SizedBox(width: 12),
              CircleAvatar(
                backgroundImage: AssetImage('assets/avatar.png'),
              )
            ],
          ),
        )
      ],
    );
  }
}
