import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Gets a user then returns the userDocument
Future<DocumentSnapshot> getUser(String userID) async {
  Future<DocumentSnapshot> userDocument =
      Firestore.instance.collection('users').document(userID).get();
  return userDocument;
}

///  Adds the post to the database
Future<DocumentReference> createPost(String caption) async {
  var currentUser = await FirebaseAuth.instance.currentUser();

  // Create Post
  var post = new Map<String, dynamic>();
  post['uid'] = currentUser.uid;
  post['caption'] = caption;
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

  return commentRef;
}

/// likes or unlikes a post
Future<DocumentReference> likePost(DocumentSnapshot postDocument) async{
  var currentUser = await FirebaseAuth.instance.currentUser();

  Map<String, dynamic> likes = new Map<String, dynamic>.from(postDocument['likes']);
  // Removes or adds like to map
  if (likes.containsKey(currentUser.uid)) {
    likes.remove(currentUser.uid);
  }else{
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

}

/// Adds document with the userid to the database
void addUser(String userID, String username, String name) async {
  var user = new Map<String, dynamic>();
  user['username'] = username;
  user['name'] = name;
  user['timestamp'] = FieldValue.serverTimestamp();
  await Firestore.instance.collection('users').document(userID).setData(user);
}
