import 'package:flutter/material.dart';
import 'package:musicsocial/helpers/database_helper.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        centerTitle: true,
      ),
      body: PostForm(),
    );
  }
}

class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() {
    return _PostFormState();
  }
}

class _PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  final captionController = TextEditingController();
  final songController = TextEditingController();
  final songURIController = TextEditingController();
  int songType = 0;

  void _songTypeChange(int value) {
    setState(() {
      songType = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 17.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: songController,
              decoration: const InputDecoration(
                // icon: Icon(Icons.comment),
                labelText: 'Song',
              ),
            ),
            TextFormField(
              controller: songURIController,
              decoration: const InputDecoration(
                // icon: Icon(Icons.comment),
                labelText: 'Song URI',
                hintText: 'E.g 22bvm1tH5Uv6Egvk38Xvr8'
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: songType,
                    onChanged: _songTypeChange,
                  ),
                  Text(
                    'Spotify',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                    value: 1,
                    groupValue: songType,
                    onChanged: _songTypeChange,
                  ),
                  Text(
                    'Soundcloud',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            TextFormField(
              controller: captionController,
              decoration: const InputDecoration(
                // icon: Icon(Icons.comment),
                labelText: 'Caption',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                // icon: Icon(Icons.people),
                hintText: 'Enter their username',
                labelText: 'Tag People',
              ),
              validator: (value) {
                // TODO check if user is valid user
              },
            ),
            SizedBox(height: 10),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "Post",
                style: TextStyle(fontSize: 13, color: Colors.white),
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text('Posting...')));
                  // Adds post to the database
                  createPost(captionController.text, songController.text, songURIController.text, songType);
                  Scaffold
                      .of(context)
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
