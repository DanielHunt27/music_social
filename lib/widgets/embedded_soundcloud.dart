import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbeddedSoundCloudPlayer extends StatelessWidget {
  const EmbeddedSoundCloudPlayer({
    Key key,
    this.uri,
  }) : super(key: key);

  final String uri;

  @override
  Widget build(BuildContext context) {
    String html;

    html = '<iframe width="100%" height="166" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/${this.uri}&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"></iframe>';

    return Container(
      child: WebView(
        initialUrl: Uri.dataFromString(html,mimeType: 'text/html').toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}