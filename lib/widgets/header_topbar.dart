// header_topbar.dart — Custom Top AppBar ala STAMP
import 'package:flutter/material.dart';

class HeaderTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String userName;
  final String userRole;
  final String avatarAsset;

  const HeaderTopBar({
    super.key,
    required this.title,
    required this.userName,
    required this.userRole,
    this.avatarAsset = 'assets/avatar.png',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      toolbarHeight: 72,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    userRole,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(avatarAsset),
              ),
              SizedBox(width: 12)
            ],
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72);
}
