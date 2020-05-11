import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:musicsocial/helpers/database_helper.dart';

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  File _image;
  bool spinner = false;
  String name;
  String username;
  String email;
  String password;
  String errorText = "";
  String uploadedFileURL;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        getUser(user.uid).then((user2){
          setState(() {
            username = user2['username'];
            name = user2['name'];
            uploadedFileURL = user2['profilepic'];
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${loggedInUser.uid}/profilepic');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        uploadedFileURL = fileURL;
      });
    });
  }

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
        centerTitle: true,
      ),
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
                /*TextField(
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
                ),*/
                Text('Name'),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    //labelText: 'Name',
                    hintText: name,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text('UserName'),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: InputDecoration(
                    //labelText: 'Username',
                    hintText: username,
                  ),
                ),
                /*TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),*/

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
                RaisedButton(
                    child: Text('Upload a Profile Picture'),
                    onPressed: () async {
                      await getImageCamera();
                      await uploadFile();
                    }
                ),
                Center(
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                ),
                SizedBox(
                  height: 15.0,
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
                          addUser(loggedInUser.uid, username, name, profilepic: uploadedFileURL);
                          Navigator.pop(context);
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
                    child: Text(
                      'Save',
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