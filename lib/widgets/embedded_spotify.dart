import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbeddedSpotifyPlayer extends StatelessWidget {
  const EmbeddedSpotifyPlayer({
    Key key,
    this.uri,
    this.isTrack,
    this.isAlbum,
  }) : super(key: key);

  final bool isTrack;
  final bool isAlbum;
  final String uri;

  @override
  Widget build(BuildContext context) {
    String html;

    if (isTrack) {
      html =
          '<iframe src="https://open.spotify.com/embed/track/${this.uri}" width="300" height="80" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>';
    } else if (isAlbum) {
      html =
          '<iframe src="https://open.spotify.com/embed/album/${this.uri}" width="300" height="80" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>';
    }

    return Container(
      height: 93,
      width: 350,
      color: Colors.red,
      child: WebView(
        initialUrl: Uri.dataFromString(html,mimeType: 'text/html').toString(),
        javascriptMode: JavascriptMode.unrestricted,
        
      ),
    );
  }
}
