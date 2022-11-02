import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_fitness/models/global_variables.dart';
import 'package:my_fitness/screens/map_screen.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../widgets/addPlaylistDialog.dart';
import '../utilities/spotify_service.dart';


Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const SpotifyScreen());
}

class SpotifyScreen extends StatefulWidget {
  const SpotifyScreen({Key? key}) : super(key: key);

  @override
  State<SpotifyScreen> createState() => _SpotifyScreenState();
}

bool isShuffling = false;
int isRepeatingIndex = 0;
Icon repeatIcon(int repeatingIndex) {
  switch(repeatingIndex) {
    case 0:
      return const Icon(Icons.repeat, size: 27);
    case 1:
      return const Icon(Icons.repeat_one_on_outlined, size: 27, color: Color.fromARGB(255, 211, 186, 109));
    case 2:
      return const Icon(Icons.repeat_on_outlined, size: 27, color: Color.fromARGB(255, 211, 186, 109));
    default:
      return const Icon(Icons.repeat, size: 27);
  }
}

class _SpotifyScreenState extends State<SpotifyScreen> {
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
          if (snapshot.hasData) {
            _connected = snapshot.data!.connected;
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
              : const Center(child: CircularProgressIndicator(color: Colors.green)),
          const SizedBox(height: 15),
          _connected
              ? _buildPlayerStateWidget()
              : const SizedBox(width: 0),
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
              SizedBox(
                height: 250,
                child: _connected
                    ? spotifyImageWidget(track.imageUri)
                    : const Text('Connect to see an image...'),
              ),
              const SizedBox(height:10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Text(track.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(track.artist.name!, style: const TextStyle(color: Colors.white54, fontSize: 18)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Expanded(child: IconButton(icon: Icon(Icons.skip_previous, size: 40), color: Colors.white, onPressed: skipPrevious)),
                  Expanded(
                    child: playerState.isPaused
                        ? const IconButton(icon: Icon(Icons.play_circle_fill), iconSize: 80.0, color: Colors.white, onPressed: resume)
                        : const IconButton(icon: Icon(Icons.pause_circle_filled), iconSize: 80.0, color: Colors.white, onPressed: pause),
                  ),
                  const Expanded(child: IconButton(icon: Icon(Icons.skip_next, size: 40), color: Colors.white, onPressed: skipNext))
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.exit_to_app, size: 27),
                      color: Colors.white,
                      tooltip: 'Quit',
                      onPressed: () async {
                        await SpotifySdk.pause();
                        await SpotifySdk.disconnect();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.playlist_add, size: 27),
                      tooltip: 'Add new playlist',
                      color: Colors.white,
                      onPressed: () {
                        showAlertDialog(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: repeatIcon(isRepeatingIndex),
                      color: Colors.white,
                      tooltip: 'Repeat',
                      onPressed: () async {
                        switch (isRepeatingIndex) {
                          case 0:
                            isRepeatingIndex = 1;
                            SpotifySdk.setRepeatMode(repeatMode: RepeatMode.track);
                            break;

                          case 1:
                            isRepeatingIndex = 2;
                            SpotifySdk.setRepeatMode(repeatMode: RepeatMode.context);
                            break;

                          case 2:
                            isRepeatingIndex = 0;
                            SpotifySdk.setRepeatMode(repeatMode: RepeatMode.off);
                            break;

                          default:
                            break;
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: isShuffling
                          ? const Icon(Icons.shuffle_on_outlined, size: 27, color: Color.fromARGB(255, 211, 186, 109))
                          : const Icon(Icons.shuffle, size: 27, color: Colors.white),
                      tooltip: 'Shuffle',
                      onPressed: () async {
                        if (isShuffling) {
                          isShuffling = false;
                          await SpotifySdk.setShuffle(shuffle: isShuffling);
                        } else {
                          isShuffling = true;
                          await SpotifySdk.setShuffle(shuffle: isShuffling);
                        }
                      },
                    ),
                  ),
                ],
              ),
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
        if (snapshot.hasData) {
          var playerContext = snapshot.data!;
          //print(playerContext.title + playerContext.type + playerContext.subtitle + playerContext.uri);
          return Column(
            children: <Widget>[
              Text(playerContext.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
              Text(playerContext.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> disconnect() async {
    try {
      setState(() {
        //_loading = true;
      });
      var result = await SpotifySdk.disconnect();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        //_loading = false;
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
        //_loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        //_loading = false;
      });
      setStatus('not implemented');
    }
  }

}




