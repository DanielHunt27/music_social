import 'package:flutter/material.dart';
import 'package:musicsocial/widgets/post.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Social'),
        centerTitle: true,
      ),
      body: ListView.separated(
        key: PageStorageKey(this.key),
        itemCount: 10,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
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
        },
      ),
    );
  }
}
