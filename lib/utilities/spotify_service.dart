import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger(
  //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
  printer: PrettyPrinter(
    methodCount: 2, // number of method calls to be displayed
    errorMethodCount: 8, // number of method calls if stacktrace is provided
    lineLength: 120, // width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: true,
  ),
);

Future getPlayerState() async {
  try {
    return await SpotifySdk.getPlayerState();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> pause() async {
  try {
    await SpotifySdk.pause();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> resume() async {
  try {
    await SpotifySdk.resume();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> skipNext() async {
  try {
    await SpotifySdk.skipNext();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> skipPrevious() async {
  try {
    await SpotifySdk.skipPrevious();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> seekTo() async {
  try {
    await SpotifySdk.seekTo(positionedMilliseconds: 20000);
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> seekToRelative() async {
  try {
    await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> checkIfAppIsActive(BuildContext context) async {
  try {
    var isActive = await SpotifySdk.isSpotifyAppActive;
    final snackBar = SnackBar(
        content: Text(isActive
            ? 'Spotify app connection is active (currently playing)'
            : 'Spotify app connection is not active (currently not playing)'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> play(String playlistUri) async {
  try {
    await SpotifySdk.play(spotifyUri: 'spotify:playlist:' + playlistUri);
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

void setStatus(String code, {String? message}) {
  var text = message ?? '';
  _logger.i('$code$text');
}