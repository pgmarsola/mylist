import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mylist/utils/colors.dart';

class ActionButton extends StatelessWidget {
  final Icon icon;
  final String titulo;
  final Function funcao;
  final double value;

  ActionButton(this.icon, this.titulo, this.funcao, this.value);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      onPressed: funcao,
      icon: icon,
      label: Text(
        titulo,
        style: TextStyle(color: branco),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(value))),
      color: verde2,
    );
  }
}
