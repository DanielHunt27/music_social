import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  Post(
      {Key key,
      this.username,
      this.name,
      this.caption,
      this.likes,
      this.comments,
      this.isLiked,
      this.timestamp})
      : super(key: key);

  final String username;
  final String name;
  final String caption;
  final int likes;
  final int comments;
  final String timestamp;

  final bool isLiked;
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool isLiked;

  final double mainFontSize = 15.0;
  final double secondaryFontSize = 13.0;

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
      padding: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 0),

      // color: Colors.red,
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    print("profile picture pressed");
                  },
                  child: CircleAvatar(
                    radius: 35.0,
                    // backgroundImage: AssetImage(assetName),
                  )),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: mainFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text("${widget.username} · ${widget.timestamp}",
                          style: TextStyle(
                            fontSize: mainFontSize,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    widget.caption,
                    style: TextStyle(fontSize: mainFontSize),
                  ),
                  SizedBox(height: 15),
                  Text("Embedded Player"),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: <Widget>[
              // SizedBox(width: 5),
              // Like btn
              GestureDetector(
                child: Icon(
                  ((isLiked) ? Icons.favorite_border : Icons.favorite),
                  size: 24.0,
                  color: (isLiked) ? Colors.black : Colors.red,
                ),
                onTap: () {
                  print("liked button pressed");
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
              ),
              SizedBox(width: 6),
              GestureDetector(
                child: Icon(
                  Icons.panorama_fish_eye,
                  size: 24.0,
                  color: Colors.black,
                ),
                onTap: () {
                  print("comment button pressed");
                },
              ),
              SizedBox(width: 6),
              Text("${widget.likes} likes, ${widget.comments} comments",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: secondaryFontSize,
                  )),
            ],
          ),
          // SizedBox(height: 2),
          // Divider(
          //   color: Colors.black38,
          // ),
        ],
      ),
    );
  }
}
