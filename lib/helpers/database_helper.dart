import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;


final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();


// Get secret from https://medium.com/@sokrato/storing-your-secret-keys-in-flutter-c0b9af1c0f69
class Secret {
  final String serverToken;

  Secret({this.serverToken=""});

  factory Secret.fromJson(Map<String, dynamic>jsonMap){
    return new Secret(serverToken:jsonMap["server_token"]);
  }
}

// Get secret from https://medium.com/@sokrato/storing-your-secret-keys-in-flutter-c0b9af1c0f69
class SecretLoader {
  final String secretPath;

  SecretLoader({this.secretPath});
  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.secretPath,
            (jsonStr) async {
          final secret = Secret.fromJson(json.decode(jsonStr));
          return secret;
        });
  }
}

/// Send notification to device using google cloud web api
Future<http.Response> sendNotification(String uid, int type) async{
  String message;
  String token;

  // Get token of the user
  await _db.collection('users').document(uid).collection('tokens').getDocuments().then((value) {
    value.documents.forEach((element) {
      token = element['token'];
    });
  });

  Secret secret = await SecretLoader(secretPath: "secrets.json").load();

  // Create message
  if (type == 0){
    message = "Someone liked your post";
  }else if(type == 1){
    message = "Someone commented on your post";
  }
  // Sleeping for test
  sleep(Duration(seconds: 5));

  http.Response response = await http.post(
    'https://fcm.googleapis.com/fcm/send',
     headers: <String, String>{
       'Content-Type': 'application/json',
       'Authorization': 'key=${secret.serverToken}',
     },
     body: jsonEncode(
     <String, dynamic>{
       'notification': <String, dynamic>{
         'body': message,
         'title': 'Music Social'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': token.toString(),
     },
    ),
  );
  // .then((responseValue){
  //   // print(responseValue.statusCode);
  //   // print(responseValue.body);
  // });
  return response;
}

/// Save current device token to database
/// Needed for push notifications
void saveDeviceToken() async{
  FirebaseUser currentUser = await _auth.currentUser();
  String token = await _fcm.getToken();
  
  // Add token to database
  if (token != null){
    DocumentReference tokenRef = _db.collection('users')
        .document(currentUser.uid)
        .collection('tokens')
        .document(token);

    await tokenRef.setData({
      'token' : token,
      'timestamp' : FieldValue.serverTimestamp(),
      'platform' : Platform.operatingSystem
    });
  }
}

/// Gets a user then returns the userDocument
Future<DocumentSnapshot> getUser(String userID) async {
  Future<DocumentSnapshot> userDocument =
      _db.collection('users').document(userID).get();
  return userDocument;
}

/// Creates notification for user
/// Type: 0 = Like
/// Type: 1 = Comment
Future<DocumentReference> createNotification(
    DocumentSnapshot entityDocument, int type) async {
  var currentUser = await _auth.currentUser();

  // Create Notification
  var notification = new Map<String, dynamic>();
  notification['actor_uid'] = currentUser.uid;
  notification['notifier_uid'] = entityDocument['uid'];
  notification['entity_id'] = entityDocument.documentID;
  notification['type'] = type;
  notification['timestamp'] = FieldValue.serverTimestamp();

  // Search database for notification
  return _db
      .collection('users')
      .document(entityDocument['uid'])
      .collection('notifications')
      .where('actor_uid', isEqualTo: currentUser.uid)
      .where('notifier_uid', isEqualTo: entityDocument['uid'])
      .where('entity_id', isEqualTo: entityDocument.documentID)
      .where('type', isEqualTo: type)
      .getDocuments()
      .then((querySnapshot) async {
    if (querySnapshot.documents.isEmpty) {
      // Add notification to database if doesn't exist
      final DocumentReference notificationRef = await _db
          .collection('users')
          .document(entityDocument['uid'])
          .collection('notifications')
          .add(notification);
      sendNotification(entityDocument['uid'], type);
      return notificationRef;
    } else {
      // Delete notification if it exists
      querySnapshot.documents.forEach((element) async {
        _db
            .collection('users')
            .document(entityDocument['uid'])
            .collection('notifications')
            .document(element.documentID)
            .delete();
      });
      return null;
    }
  });
}

///  Adds the post to the database
/// Type 0 - spotify
/// Type 1 - soundcloud
Future<DocumentReference> createPost(String caption, String song, String uri, int type) async {
  var currentUser = await _auth.currentUser();

  // Create Post
  var post = new Map<String, dynamic>();
  post['uid'] = currentUser.uid;
  post['caption'] = caption;
  post['song'] = song;
  post['uri'] = uri;
  post['type'] = type;
  post['likes'] = new Map<String, dynamic>();
  post['commentCount'] = 0;
  post['timestamp'] = FieldValue.serverTimestamp();

  final DocumentReference postRef = await _db
      .collection('users')
      .document(currentUser.uid)
      .collection('posts')
      .add(post);
  return postRef;
}

/// Returns a stream of a posts comments
Stream<QuerySnapshot> getComments(DocumentSnapshot postDocument) {
  return _db
      .collection('users')
      .document(postDocument['uid'])
      .collection('posts')
      .document(postDocument.documentID)
      .collection('comments')
      .snapshots();
}

/// Adds the comment to the post by the user
Future<DocumentReference> addComment(
    DocumentSnapshot postDocument, String commentString) async {
  var currentUser = await _auth.currentUser();

  var comment = new Map<String, dynamic>();
  comment['uid'] = currentUser.uid;
  comment['comment'] = commentString;
  comment['timestamp'] = FieldValue.serverTimestamp();

  // Add the comment
  final DocumentReference commentRef = await _db
      .collection('users')
      .document(postDocument['uid'])
      .collection('posts')
      .document(postDocument.documentID)
      .collection('comments')
      .add(comment);

  // Update the comment counter
  var post = new Map<String, dynamic>();
  post['commentCount'] = FieldValue.increment(1);
  await _db
      .collection('users')
      .document(postDocument['uid'])
      .collection('posts')
      .document(postDocument.documentID)
      .updateData(post);

  // Create the notification
  createNotification(postDocument, 1);

  return commentRef;
}

/// likes or unlikes a post
void likePost(DocumentSnapshot postDocument) async {
  var currentUser = await _auth.currentUser();

  Map<String, dynamic> likes =
      new Map<String, dynamic>.from(postDocument['likes']);
  // Removes or adds like to map
  if (likes.containsKey(currentUser.uid)) {
    likes.remove(currentUser.uid);
  } else {
    likes.putIfAbsent(currentUser.uid, () => true);
  }

  var post = new Map<String, dynamic>();
  post['likes'] = likes;

  await _db
      .collection('users')
      .document(postDocument['uid'])
      .collection('posts')
      .document(postDocument.documentID)
      .updateData(post);

  // Create the notification
  createNotification(postDocument, 0);
}

/// Adds document with the userid to the database
void addUser(String userID, String username, String name,
    {String profilepic =
        'https://firebasestorage.googleapis.com/v0/b/music-social-f66b8.appspot.com/o/default-profile-picture1.jpg?alt=media&token=f6c13df3-ce20-4a5d-a771-77db612165f1'}) async {
  var user = new Map<String, dynamic>();
  user['username'] = username;
  user['name'] = name;
  user['timestamp'] = FieldValue.serverTimestamp();
  user['profilepic'] = profilepic;
  await _db.collection('users').document(userID).setData(user);
}
