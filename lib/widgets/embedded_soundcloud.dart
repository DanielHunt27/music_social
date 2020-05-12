import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';

class EmbeddedSoundCloudPlayer extends StatelessWidget {
  const EmbeddedSoundCloudPlayer({
    Key key,
    this.uri,
  }) : super(key: key);

  final String uri;

  Future scrape() async {
    String id;
    var client = Client();
    Response response = await client.get(this.uri);

    RegExp regex = new RegExp(
      r"soundcloud://sounds:\d+",
      caseSensitive: true,
      multiLine: false,
    );
    RegExp idReg = new RegExp(
      r"\d+",
      caseSensitive: false,
      multiLine: false,
    );
    id = regex.stringMatch(response.body).toString();
    return idReg.stringMatch(id).toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: scrape(),
      builder: (context, snapshot) {

        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              String html = '<iframe width="100%" height="100" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/${snapshot.data}&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"></iframe>';
              return Container(
                child: WebView(
                  initialUrl: Uri.dataFromString(html, mimeType: 'text/html')
                      .toString(),
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              );
            }
        }
      }
    );
  }
}
