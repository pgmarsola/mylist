import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mylist/utils/colors.dart';
import 'package:mylist/widgets/action_button.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _userEmail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController.text = '';
    _passwordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height / 100;

    return Scaffold(
      backgroundColor: branco,
      appBar: AppBar(
        backgroundColor: branco,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: verde2,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: screenHeight * 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenHeight * 12,
                    width: screenHeight * 12,
                    child: Image.asset(
                      'assets/icon.png',
                      scale: screenHeight * 2,
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [verde2, azul],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft),
                        borderRadius: BorderRadius.all(Radius.circular(45))),
                  ),
                  SizedBox(
                    width: screenHeight * 2,
                  ),
                  Text(
                    'MyList',
                    style: TextStyle(
                        color: azul,
                        fontSize: screenHeight * 5,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 5,
              ),
              Padding(
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (valor) {
                    if (valor.isEmpty && valor.length == 0) {
                      return "Campo Obrigatório";
                    }
                  },
                  decoration: new InputDecoration(
                    hintText: 'E-mail',
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: verde2),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: verde2),
                      borderRadius: BorderRadius.circular(screenHeight * 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: verde2),
                      borderRadius: BorderRadius.circular(screenHeight * 1.5),
                    ),
                  ),
                ),
                padding: EdgeInsets.all(screenHeight * 1.5),
              ),
              Padding(
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  validator: (valor) {
                    if (valor.isEmpty && valor.length == 0) {
                      return "Campo Obrigatório";
                    }
                  },
                  decoration: new InputDecoration(
                    hintText: 'Senha',
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: verde2),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: verde2),
                      borderRadius: BorderRadius.circular(screenHeight * 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: verde2),
                      borderRadius: BorderRadius.circular(screenHeight * 1.5),
                    ),
                  ),
                ),
                padding: EdgeInsets.all(screenHeight * 1.5),
              ),
              ActionButton(
                  Icon(
                    Icons.arrow_forward_ios,
                    color: branco,
                  ),
                  ('Cadastrar-se').toUpperCase(), () async {
                if (_formKey.currentState.validate()) {
                  _register(context);
                }
              }, screenHeight * 1.5),
              Container(
                margin: EdgeInsets.all(screenHeight * 1.5),
                alignment: Alignment.center,
                child: Text(_userEmail == null
                    ? ''
                    : (_userEmail != null
                        ? 'Usuário $_userEmail foi registrado com sucesso'
                        : 'Falha ao tentar registrar usuário')),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      if (user != null) {
        _emailController.text = '';
        _passwordController.text = '';
        _userEmail = user.user.email;
      }
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Falha ao criar registro"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }
}
