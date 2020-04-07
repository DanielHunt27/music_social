import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  NotificationWidget(
      {Key key,
      this.username,
      this.notification,
      this.caption,
      this.isPost,
      this.post,
      this.timestamp})
      : super(key: key);

  final String username;
  final String notification;
  final String caption;
  final bool isPost;
  final String post;
  final String timestamp;

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  bool doesUserFollow = false; // TODO check if user follows from DB

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print("notication pressed");
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
                          radius: 22.0,
                          // backgroundImage: AssetImage(assetName),
                        )),
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
                              text: "${widget.username}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: " ${widget.notification}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            TextSpan(
                              text: " ${widget.timestamp}",
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
              (widget.isPost)
                  ? Image(
                      // TODO Add song cover image
                      image: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/en/b/b7/NirvanaNevermindalbumcover.jpg"),
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
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
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
        ));
  }
}
