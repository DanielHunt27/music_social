import 'package:flutter/material.dart';
import 'package:musicsocial/widgets/post.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Music Social'),
          centerTitle: true,
        ),
        body: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: new Post(
                  username: "@username$index",
                  name: "Name $index",
                  caption: "Caption $index",
                  likes: 100,
                  comments: 2,
                  isLiked: true,
                  timestamp: "${index * 3 + 1}m",
                ));
          },
        ));
  }
}
