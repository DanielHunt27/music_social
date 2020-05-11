import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:musicsocial/pages/page_manager.dart';
import 'package:musicsocial/helpers/database_helper.dart';
import 'package:musicsocial/pages/register_page.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;
  bool spinner = false;
  String name;
  String username;
  String email;
  String password;
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Music Social",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  // hintText: 'Email Address',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: '',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                errorText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: 7.0,
              ),
              Material(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: MaterialButton(
                  onPressed: () async {
                    setState(() {
                      spinner = true;
                    });
                    try {
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => PageManager()),
                        );
                        saveDeviceToken();
                      }
                    } catch (e) {
                      print(e);
                      setState(() {
                        errorText = e.message;
                      });
                    }
                    setState(() {
                      spinner = false;
                    });
                  },
                  //minWidth: 200.0,
                  //height: 42.0,
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
              ),
              Material(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: MaterialButton(
                  onPressed: () async {
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                  //minWidth: 200.0,
                  //height: 35.0,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
