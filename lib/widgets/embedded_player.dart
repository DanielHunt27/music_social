import 'package:flutter/material.dart';
import 'package:musicsocial/widgets/embedded_soundcloud.dart';
import 'package:musicsocial/widgets/embedded_spotify.dart';

class EmbeddedPlayer extends StatelessWidget {
  EmbeddedPlayer({Key key, this.isSpotify, this.isSoundcloud, this.uri});

  final bool isSpotify;
  final bool isSoundcloud;

  final String uri;

  @override
  Widget build(BuildContext context) {
    if (isSpotify) {
      return EmbeddedSpotifyPlayer(uri: this.uri, isTrack: true, isAlbum: false);
    } else if (isSoundcloud){
      return EmbeddedSoundCloudPlayer(uri: this.uri);
    }
    return Container(
    );
  }
}