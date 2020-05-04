import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musicsocial/helpers/database_helper.dart';
import 'package:musicsocial/helpers/helper_functions.dart';
import 'package:musicsocial/pages/post_view_comments_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicsocial/pages/profile_page.dart';
import 'package:musicsocial/widgets/embedded_player.dart';

class Post extends StatefulWidget {
  Post({Key key, this.postDocument}) : super(key: key);

  final DocumentSnapshot postDocument;

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  String username = "Loading...";
  String name = "Loading...";
  int likeCount = 0;
  Map<String, dynamic> likes;
  bool hasLiked = false;
  
  String caption;
  String timestamp;
  int commentCount;

  final double mainFontSize = 15.0;
  final double secondaryFontSize = 13.0;

  @override
  void initState(){
    // Get user info
    getUser(widget.postDocument['uid']).then((user){
      setState(() {
        username = user['username'];
        name = user['name'];
      });
    });

    // Get likes
    try { 
      likes = new Map<String, dynamic>.from(widget.postDocument['likes']);
      likeCount = likes.length;
    }  
    catch (e) {
    }

    // Check if current user has liked it
    FirebaseAuth.instance.currentUser().then((currentUser){
      if (likes != null && likes.containsKey(currentUser.uid)) {
        setState(() {
          hasLiked = true;
        });
      }
    });

    
    caption = widget.postDocument['caption'];
    timestamp = getTimeDifference(widget.postDocument['timestamp'].toDate());
    commentCount = widget.postDocument['commentCount'];

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      // height: 120,
      // decoration: BoxDecoration(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        ProfilePage(uid: widget.postDocument['uid'])),
                  );
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
                    caption,
                    style: TextStyle(fontSize: mainFontSize),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ],
          ),
          SizedBox(height: 7),
          EmbeddedPlayer(isSpotify: true, uri: "466cKvZn1j45IpxDdYZqdA"),
          // EmbeddedPlayer(isSoundcloud: true, uri: "805856467"),
          SizedBox(height: 12),
          Row(
            children: <Widget>[
              // SizedBox(width: 5),
              // Like btn
              GestureDetector(
                child: Icon(
                  ((hasLiked) ? Icons.favorite : Icons.favorite_border),
                  size: 24.0,
                  color: (hasLiked) ? Colors.red : Colors.black,
                ),
                onTap: () {
                  likePost(widget.postDocument);
                  setState(() {
                    hasLiked = !hasLiked;
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
                  viewComments();
                },
              ),
              SizedBox(width: 6),
              Text(
                "${this.likeCount} likes, ${this.commentCount} comments",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: secondaryFontSize,
                ),
              ),
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

  void viewComments() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PostViewComments(postDocument: widget.postDocument)),
    );
  }
}
