import 'package:flutter/material.dart';

class GradientColor extends StatelessWidget {
  var right;
  var left;

  GradientColor(this.right, this.left);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [right, left],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft)),
    );
  }
}
