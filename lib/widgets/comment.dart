import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicsocial/helpers/database_helper.dart';
import 'package:musicsocial/helpers/helper_functions.dart';

class Comment extends StatefulWidget {
  Comment({Key key, this.comment})
      : super(key: key);


  final DocumentSnapshot comment;

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  String username = 'Loading...';
  String name = 'Loading...';
    String comment;
  String timestamp;

  final double mainFontSize = 15.0;
  final double secondaryFontSize = 13.0;

  @override
  void initState() {
    getUser(widget.comment['uid']).then((user){
      setState(() {
        name = user['name'];
        username = user['username'];
      });
    });
    comment = widget.comment['comment'];
    
    timestamp = getTimeDifference(widget.comment['timestamp'].toDate());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 0),
      child: Column(
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
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        this.name,
                        style: TextStyle(
                          fontSize: mainFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "${this.username} · ${this.timestamp}",
                        style: TextStyle(
                          fontSize: mainFontSize,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    this.comment,
                    style: TextStyle(fontSize: mainFontSize),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
