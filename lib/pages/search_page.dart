import 'package:flutter/material.dart';
import 'package:musicsocial/widgets/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String filter;
  var _firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          TextField(
            textAlign: TextAlign.center,
            onChanged: (value) {
              filter = value;
            },
            decoration: InputDecoration(
              hintText: 'Search',
            ),
          ),
          RaisedButton(
              child: Text('Search'),
              onPressed: () {
                setState(() {
                  _firestore = Firestore.instance.collectionGroup('posts')
                      .where('song', isEqualTo: filter).snapshots();
                });
              }),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: Text('No songs match that search'));
                  return ListView.separated(
                    //key: PageStorageKey(this.key),
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
          ),
        ],
      ),
    );
  }
}
