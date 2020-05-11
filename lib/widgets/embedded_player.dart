import 'package:flutter/material.dart';
import 'package:musicsocial/widgets/embedded_soundcloud.dart';
import 'package:musicsocial/widgets/embedded_spotify.dart';

class EmbeddedPlayer extends StatelessWidget {
  EmbeddedPlayer({Key key, this.uri, this.type});

  final int type;
  final String uri;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 0:
        return EmbeddedSpotifyPlayer(uri: this.uri);
        break;
      case 1:
        return Container(
          height: 180,
          child: EmbeddedSoundCloudPlayer(uri: this.uri),
        );
        break;
      default:
        return Container();
    }
  }
}
