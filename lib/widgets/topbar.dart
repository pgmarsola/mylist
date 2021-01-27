import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mylist/utils/colors.dart';
import 'package:mylist/utils/gradient_color.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  TopBar();

  Size get preferredSize {
    return new Size.fromHeight(50.0);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('MyList'),
      leading: Image.asset(
        'assets/icon.png',
        scale: 20,
      ),
      actions: [
        IconButton(
          color: Colors.white,
          icon: Icon(
            Icons.exit_to_app,
          ),
          onPressed: () {
            exit(0);
          },
        )
      ],
      flexibleSpace: GradientColor(verde2, azul),
    );
  }
}
