import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:musicsocial/pages/page_manager.dart';
import 'package:musicsocial/helpers/database_helper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
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
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          // Add username to the user
                          UserUpdateInfo userUpdateInfo = UserUpdateInfo();
                          userUpdateInfo.displayName = name;
                          newUser.user.updateProfile(userUpdateInfo);
                          addUser(newUser.user.uid, username, name);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageManager()),
                          );
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
                    //height: 35.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Text(
                  "Already have an account?",
                  textAlign: TextAlign.center,
                ),
                Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    //minWidth: 200.0,
                    //height: 35.0,
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
