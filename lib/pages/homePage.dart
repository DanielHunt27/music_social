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
        body: Column(
          children: <Widget>[
            new Post(
                username: "@username",
                name: "Name",
                caption: "Caption",
                likes: 100,
                comments: 2,
                isLiked: true),
            new Post(
                username: "@username",
                name: "Name",
                caption: "Caption",
                likes: 100,
                comments: 2,
                isLiked: true),
          ],
        ));
  }
}
