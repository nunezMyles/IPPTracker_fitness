import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_fitness/models/global_variables.dart';
import 'package:my_fitness/screens/map_screen.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../widgets/addPlaylistDialog.dart';


Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const SpotifyScreen());
}

class SpotifyScreen extends StatefulWidget {
  const SpotifyScreen({Key? key}) : super(key: key);

  @override
  State<SpotifyScreen> createState() => _SpotifyScreenState();
}

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

class _SpotifyScreenState extends State<SpotifyScreen> {
  bool _loading = false;
  bool _connected = false;
  late ImageUri? currentTrackImageUri;


  @override
  Widget build(BuildContext context) {

    SpotifySdk.connectToSpotifyRemote(
      clientId: spotifyClientID,
      redirectUrl: spotifyRedirectUrl,
    );

    return SafeArea(
      child: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return _mainWidgetBuilder(context);
        },
      ),
    );
  }

  Widget _mainWidgetBuilder(BuildContext context2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _connected
              ? _buildPlayerContextWidget()
              : const Center(child: Text('Not connected')),

          const SizedBox(height: 15),

          _connected
              ? _buildPlayerStateWidget()
              : const Center(child: Text('Not connected')),

          Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.queue_music, size: 25),
                  color: Colors.white,

                  onPressed: () {},
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.playlist_add, size: 25),
                  tooltip: 'Add new playlist',
                  color: Colors.white,
                  onPressed: () {
                    showAlertDialog(context);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.repeat, size: 25),
                  color: Colors.white,
                  onPressed: () async => await SpotifySdk.toggleRepeat(),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.shuffle, size: 25),
                  color: Colors.white,
                  onPressed: () async => await SpotifySdk.toggleShuffle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var track = snapshot.data?.track;
          currentTrackImageUri = track?.imageUri;
          var playerState = snapshot.data;

          if (playerState == null || track == null) {
            return Center(
              child: Container(),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //Text('Progress: ${snapshot.data!.playbackPosition}ms/${snapshot.data!.track?.duration}ms', style: const TextStyle(color: Colors.white),),

              SizedBox(
                height: 250,
                child: _connected
                    ? spotifyImageWidget(track.imageUri)
                    : const Text('Connect to see an image...'),
              ),
              const SizedBox(height:10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(track.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(track.artist.name!, style: const TextStyle(color: Colors.white54, fontSize: 18))
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: IconButton(icon: const Icon(Icons.skip_previous, size: 40), color: Colors.white, onPressed: skipPrevious)),
                  Expanded(
                    child: playerState.isPaused
                        ? IconButton(icon: const Icon(Icons.play_circle_fill), iconSize: 80.0, color: Colors.white, onPressed: resume)
                        : IconButton(icon: const Icon(Icons.pause_circle_filled), iconSize: 80.0, color: Colors.white, onPressed: pause),
                  ),
                  Expanded(child: IconButton(icon: const Icon(Icons.skip_next, size: 40), color: Colors.white, onPressed: skipNext))
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }

      },
    );
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Getting image...')),
            );
          }
        });
  }

  Widget _buildPlayerContextWidget() {
    return StreamBuilder<PlayerContext>(
      stream: SpotifySdk.subscribePlayerContext(),
      initialData: PlayerContext('', '', '', ''),
      builder: (BuildContext context, AsyncSnapshot<PlayerContext> snapshot) {
        var playerContext = snapshot.data;
        if (playerContext == null) {
          return const Center(
            child: Text('Not connected'),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(playerContext.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 17)),
            Text(playerContext.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),

            //Text('Type: ${playerContext.type}'),
            //Text('Uri: ${playerContext.uri}'),
          ],
        );
      },
    );
  }
  /*
  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedIconButton(
                width: 50,
                icon: Icons.queue_music,
                color: Colors.white,
                onPressed: () {},
              ),
              SizedIconButton(
                width: 50,
                icon: Icons.playlist_play,
                color: Colors.white,
                onPressed: play,
              ),
              SizedIconButton(
                width: 50,
                icon: Icons.repeat,
                color: Colors.white,
                onPressed: () {},
              ),
              SizedIconButton(
                width: 50,
                icon: Icons.shuffle,
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedIconButton(
                width: 50,
                color: Colors.white,
                onPressed: () {},
                icon: Icons.favorite,
              ),
              SizedIconButton(
                width: 50,
                color: Colors.white,
                onPressed: () => checkIfAppIsActive(context),
                icon: Icons.info,
              ),
            ],
          ),
        ],
      ),
    );
  }
*/

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        _loading = false;
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation
              ) => const MapScreen(),
          transitionDuration: const Duration(milliseconds: 50),
          transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,) => FadeTransition(opacity: animation, child: child),
        ));
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

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


