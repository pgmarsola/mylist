import 'package:flutter/material.dart';
import 'package:mylist/utils/colors.dart';

class FormText extends StatelessWidget {
  String titulo;
  TextEditingController _controller;

  FormText(this.titulo, this._controller);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height / 100;

    return TextFormField(
      controller: this._controller,
      keyboardType: TextInputType.text,
      validator: (valor) {
        if (valor.isEmpty && valor.length == 0) {
          return "Campo Obrigatório";
        }
      },
      decoration: new InputDecoration(
        hintText: this.titulo,
        labelText: this.titulo,
        labelStyle: TextStyle(color: verde2),
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: verde2),
          borderRadius: BorderRadius.circular(screenHeight * 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: verde2),
          borderRadius: BorderRadius.circular(screenHeight * 1.5),
        ),
      ),
    );
  }
}
