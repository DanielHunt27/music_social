import 'package:flutter/material.dart';
//import 'package:musicsocial/pages/page_manager.dart';
import 'package:musicsocial/pages/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      //home: PageManager(),
      home: SignIn(),
    );
  }
}
