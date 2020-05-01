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
          stream: Firestore.instance.collectionGroup('posts').snapshots(),              
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
            return ListView.separated(
              key: PageStorageKey(this.key),
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
          }),
    );
  }
}
