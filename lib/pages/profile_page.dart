import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicsocial/pages/edit_account_page.dart';
import 'package:musicsocial/widgets/post.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  ProfilePage({Key key, this.uid}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var profileData;
  String uid;
  String username = 'Loading...', name = 'Loading...';
  var posts = new List();
  FirebaseUser loggedInUser;
  Widget button = OutlineButton(
    child: Text('Loading...'),
    onPressed: () {
      print('button pressed');
    },
  );
  Widget avatar = CircleAvatar(radius: 50);

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      if (widget.uid == '-_@_-') {
        uid = user.uid;
        button = OutlineButton(
          child: Text('Edit Account'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  EditAccountPage()),
            );
          },
        );
      } else {
        uid = widget.uid;
        button = OutlineButton(
          child: Text('Follow'),
          onPressed: () {
            print('button pressed');
          },
        );
      }
      loggedInUser = user;
      if (uid != null) {
        final profileData = await Firestore.instance.collection('users')
            .document(uid).get();
        setState(() {
          name = profileData.data['name'];
          username = profileData.data['username'];
          avatar = CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profileData.data['profilepic']),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }



  /*
  * There's two different styles of scrolling, but not sure which one looks better
  */
  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(uid)
            .collection('posts')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.separated(
            //key: PageStorageKey(this.key),
            itemCount: snapshot.data.documents.length + 1,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          right: 30,
                          top: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 50,
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(username),
                                OutlineButton(
                                  child: Text('Follow'),
                                  onPressed: () {
                                    print('button pressed');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Post(
                    postDocument: snapshot.data.documents[index - 1],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30,
              top: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                avatar,
                Column(
                  children: <Widget>[
                    Text(name,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(username),
                    button,
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('users')
                  .document(uid).collection('posts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.separated(
                  itemCount: snapshot.data.documents.length,
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Post(
                        postDocument: snapshot.data.documents[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
