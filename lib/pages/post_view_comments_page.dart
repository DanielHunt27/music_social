import 'package:flutter/material.dart';
import 'package:musicsocial/helpers/database_helper.dart';
import 'package:musicsocial/widgets/post.dart';
import 'package:musicsocial/widgets/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostViewComments extends StatelessWidget {
  PostViewComments(
      {Key key, @required this.postDocument})
      : super(key: key);

  final DocumentSnapshot postDocument;  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            // TODO get post information from DB
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Post(
              postDocument: this.postDocument,
            ),
          ),
          CommentForm(postDocument: postDocument),
          Expanded(
            // height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: getComments(postDocument),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView.separated(
                  key: PageStorageKey(this.key),
                  itemCount: snapshot.data.documents.length,
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemBuilder: (context, index) {
                    // read data from firebase
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Comment(
                        comment: snapshot.data.documents[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommentForm extends StatefulWidget {
  CommentForm({Key key, @required this.postDocument});

  final DocumentSnapshot postDocument;
  @override
  _CommentFormState createState() {
    return _CommentFormState();
  }
}

class _CommentFormState extends State<CommentForm> {
  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Add Comment',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a comment';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "Comment",
                style: TextStyle(fontSize: 13, color: Colors.white),
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Posting...')));
                  // TODO Add comment to database
                  addComment(widget.postDocument, commentController.text);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Posted')));
                }
              },
              padding: EdgeInsets.all(5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
