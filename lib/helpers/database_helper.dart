import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Gets a user then returns the userDocument
Future<DocumentSnapshot> getUser(String userID) async {
  Future<DocumentSnapshot> userDocument =
      Firestore.instance.collection('users').document(userID).get();
  return userDocument;
}

/// Creates notification for user
/// Type: 0 = Like
/// Type: 1 = Comment
Future<DocumentReference> createNotification(
    DocumentSnapshot entityDocument, int type) async {
  var currentUser = await FirebaseAuth.instance.currentUser();

  // Create Notification
  var notification = new Map<String, dynamic>();
  notification['actor_uid'] = currentUser.uid;
  notification['notifier_uid'] = entityDocument['uid'];
  notification['entity_id'] = entityDocument.documentID;
  notification['type'] = type;
  notification['timestamp'] = FieldValue.serverTimestamp();

  // Search database for notification
  return Firestore.instance
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
      final DocumentReference notificationRef = await Firestore.instance
          .collection('users')
          .document(entityDocument['uid'])
          .collection('notifications')
          .add(notification);
      return notificationRef;
    } else {
      // Delete notification if it exists
      querySnapshot.documents.forEach((element) async {
        Firestore.instance
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
Future<DocumentReference> createPost(String caption, String song) async {
  var currentUser = await FirebaseAuth.instance.currentUser();

  // Create Post
  var post = new Map<String, dynamic>();
  post['uid'] = currentUser.uid;
  post['caption'] = caption;
  post['song'] = song;
  post['likes'] = new Map<String, dynamic>();
  post['commentCount'] = 0;
  post['timestamp'] = FieldValue.serverTimestamp();

  final DocumentReference postRef = await Firestore.instance
      .collection('users')
      .document(currentUser.uid)
      .collection('posts')
      .add(post);
  return postRef;
}

/// Returns a stream of a posts comments
Stream<QuerySnapshot> getComments(DocumentSnapshot postDocument) {
  return Firestore.instance
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
  var currentUser = await FirebaseAuth.instance.currentUser();

  var comment = new Map<String, dynamic>();
  comment['uid'] = currentUser.uid;
  comment['comment'] = commentString;
  comment['timestamp'] = FieldValue.serverTimestamp();

  // Add the comment
  final DocumentReference commentRef = await Firestore.instance
      .collection('users')
      .document(postDocument['uid'])
      .collection('posts')
      .document(postDocument.documentID)
      .collection('comments')
      .add(comment);

  // Update the comment counter
  var post = new Map<String, dynamic>();
  post['commentCount'] = FieldValue.increment(1);
  await Firestore.instance
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
Future<DocumentReference> likePost(DocumentSnapshot postDocument) async {
  var currentUser = await FirebaseAuth.instance.currentUser();

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

  await Firestore.instance
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
  await Firestore.instance.collection('users').document(userID).setData(user);
}
