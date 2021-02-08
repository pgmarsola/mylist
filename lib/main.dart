import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mylist/screens/login.dart';
import 'package:mylist/screens/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('Erro');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Login(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: Container(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
