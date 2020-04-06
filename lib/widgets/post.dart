import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  Post(
      {Key key,
      this.username,
      this.name,
      this.caption,
      this.likes,
      this.comments,
      this.isLiked})
      : super(key: key);

  final String username;
  final String name;
  final String caption;
  final int likes;
  final int comments;

  final bool isLiked;
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool isLiked;

  @override
  void initState() {
    isLiked = widget.isLiked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120,
      // decoration: new BoxDecoration(
      //     color: Colors.white, boxShadow: [BoxShadow(color: Colors.black)]),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    print("profile picture pressed");
                  },
                  child: Container(
                    width: 75,
                    height: 75,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        // image: DecorationImage(
                        //     image: new AssetImage(null), fit: BoxFit.fill),
                        color: Colors.red,
                        shape: BoxShape.circle),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(widget.name),
                      SizedBox(width: 20),
                      Text(
                        widget.username,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(widget.caption),
                  SizedBox(height: 15),
                  Text("Embedded Player"),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(width: 10),
              // Like btn
              GestureDetector(
                child: Icon(
                  ((isLiked) ? Icons.favorite_border : Icons.favorite),
                  size: 30,
                  color: (isLiked) ? Colors.black : Colors.red,
                ),
                onTap: () {
                  print("liked button pressed");
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
              ),
              SizedBox(width: 2),
              GestureDetector(
                child: Icon(
                  Icons.panorama_fish_eye,
                  size: 30,
                  color: Colors.black,
                ),
                onTap: () {
                  print("comment button pressed");
                },
              ),
              SizedBox(width: 10),
              Text(widget.likes.toString() + " likes, ",
                  style: TextStyle(color: Colors.grey)),
              // Text(", "),
              // SizedBox(width: 20),
              Text(widget.comments.toString() + " comments",
                  style: TextStyle(color: Colors.grey)),
              // Like count
              // Comment count
            ],
          ),
          SizedBox(height: 2),
          Divider(
            color: Colors.black38,
          ),
        ],
      ),
    );
  }
}
