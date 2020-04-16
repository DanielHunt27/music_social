import 'package:flutter/material.dart';
import 'package:musicsocial/widgets/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Social'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').document('UserEmail@email.com').collection('posts').snapshots(),
        builder: (context, snapshot) {
          return ListView.separated(
            key: PageStorageKey(this.key),
            itemCount: 10,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                // read data from firebase
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Post(
                    username: "@${snapshot.data.documents[0]['username']}",
                    name: "${snapshot.data.documents[0]['songname']}",
                    caption: "${snapshot.data.documents[0]['caption']}",
                    likes: snapshot.data.documents[0]['likes'],
                    comments: snapshot.data.documents[0]['numcomments'],
                    isLiked: snapshot.data.documents[0]['isLiked'],
                    //need to calculate time from timestamp
                    timestamp: "${index * 3 + 1}m",
                  ),
                );
              } else {
                // load static data
                return Container(
                  // TODO get post information from DB
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Post(
                    username: "@username$index",
                    name: "Name $index",
                    caption: "Caption $index",
                    likes: 100,
                    comments: 2,
                    isLiked: true,
                    timestamp: "${index * 3 + 1}m",
                  ),
                );
              }
            },
          );
        }
      ),
    );
  }
}
