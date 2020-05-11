import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicsocial/helpers/database_helper.dart';
import 'package:musicsocial/helpers/helper_functions.dart';
import 'package:musicsocial/pages/post_view_comments_page.dart';

class NotificationWidget extends StatefulWidget {
  NotificationWidget({Key key, this.notificationDocument}) : super(key: key);

  final DocumentSnapshot notificationDocument;

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  String username = "Loading...";
  String name = "Loading...";
  NetworkImage profilepic;

  int type = -1;
  String notification;
  String timestamp;

  bool isPost = true;
  DocumentSnapshot postDocument;

  bool doesUserFollow = false; // TODO check if user follows from DB

  @override
  void initState() {
    // Get user info
    getUser(widget.notificationDocument['actor_uid']).then((user) {
      setState(() {
        username = user['username'];
        name = user['name'];
        profilepic = NetworkImage(user['profilepic']);
      });
    });

    type = widget.notificationDocument['type'];
    if (type == 0) {
      isPost = true;
      notification = "liked your post";
    } else if (type == 1) {
      isPost = true;
      notification = "commented on your post";
    }
    timestamp =
        getTimeDifference(widget.notificationDocument['timestamp'].toDate());

    // Get post document
    Firestore.instance
        .collection('users')
        .document(widget.notificationDocument['notifier_uid'])
        .collection('posts')
        .document(widget.notificationDocument['entity_id'])
        .get()
        .then((value) => this.postDocument = value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("notication pressed");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PostViewComments(postDocument: this.postDocument)),
        );
      },
      child: Container(
        // margin: EdgeInsets.all(0),
        // color: Colors.red,
        padding: EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("profile picture pressed");
                    },
                    child: CircleAvatar(
                      radius: 35.0,
                      backgroundImage: profilepic,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.only(top: 2),
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "${this.username}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: " ${this.notification}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: " ${this.timestamp}",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (this.isPost)
                ? Image(
                    // TODO Add song cover image
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/music-social-f66b8.appspot.com/o/albumcover-placeholder.jpg?alt=media&token=21edca1a-2264-40b8-8802-703e479a8b35"),
                    width: 55,
                    height: 55,
                  )
                : Container(
                    width: 80,
                    height: 26,
                    child: RaisedButton(
                      color: (doesUserFollow)
                          ? Colors.white
                          : Theme.of(context).accentColor,
                      child: (doesUserFollow)
                          ? Text(
                              "Following",
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            )
                          : Text(
                              "Follow",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                      onPressed: () {
                        setState(() {
                          // TODO Database action to follow user
                          doesUserFollow = !doesUserFollow;
                          print("Follow button pressed");
                        });
                      },
                      padding: EdgeInsets.all(5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.12),
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
