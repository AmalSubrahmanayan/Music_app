// ignore_for_file: unused_import

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/db/favoritebtn.dart';
import 'package:musicapp/db/favoritedb.dart';
import 'package:musicapp/db/playlist_db.dart';
import 'package:musicapp/screens/miniplayer.dart';
import 'package:musicapp/screens/next.dart';
import 'package:on_audio_query/on_audio_query.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import 'package:lottie/lottie.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key, required this.playerSong}) : super(key: key);
  final List<SongModel> playerSong;

  @override
  State<PlayScreen> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<PlayScreen> {
  bool _isPlaying = true;
  late int currentIndex;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    Getsong.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  iconSize: 50,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  onPressed: () {
                    Navigator.pop(context);

                    refreshNotifier.notifyListeners();
                  }),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QueryArtworkWidget(
                        keepOldArtwork: true,
                        id: widget.playerSong[currentIndex].id,
                        quality: 100,
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.cover,
                        artworkBorder: BorderRadius.circular(35),
                        artworkWidth: 200,
                        artworkHeight: 250,
                        nullArtworkWidget: Lottie.asset(
                          'assets/images/play.json',
                          height: 250,
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.playerSong[currentIndex].displayNameWOExt,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      color: const Color.fromARGB(255, 252, 252, 252),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.playerSong[currentIndex].artist.toString() ==
                            "<unknown>"
                        ? "unknown artist"
                        : widget.playerSong[currentIndex].artist.toString(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      showSliderDialog(
                          context: context,
                          title: "Adjust volume",
                          divisions: 10,
                          min: 0.0,
                          max: 1.0,
                          value: Getsong.player.volume,
                          stream: Getsong.player.volumeStream,
                          onChanged: Getsong.player.setVolume);
                    },
                    color: Colors.white,
                    icon: const Icon(Icons.volume_down_alt),
                    iconSize: 28,
                  ),
                  FavoriteBt(song: widget.playerSong[currentIndex])
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<DurationState>(
                  stream: _durationStateStream,
                  builder: (context, snapshot) {
                    final durationState = snapshot.data;
                    final progress = durationState?.position ?? Duration.zero;
                    final total = durationState?.total ?? Duration.zero;
                    return ProgressBar(
                        timeLabelTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        progress: progress,
                        total: total,
                        barHeight: 4.0,
                        thumbRadius: 7,
                        progressBarColor:
                            const Color.fromARGB(255, 149, 167, 232),
                        thumbColor: const Color.fromARGB(255, 149, 167, 232),
                        baseBarColor: const Color.fromARGB(255, 255, 255, 255),
                        bufferedBarColor:
                            const Color.fromARGB(255, 253, 254, 255),
                        buffered: const Duration(milliseconds: 2000),
                        onSeek: (duration) {
                          Getsong.player.seek(duration);
                        });
                  }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<bool>(
                    stream: Getsong.player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: _shuffleButton(context, snapshot.data ?? false),
                      );
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: StreamBuilder<LoopMode>(
                      stream: Getsong.player.loopModeStream,
                      builder: (context, snapshot) {
                        return _repeatButton(
                            context, snapshot.data ?? LoopMode.off);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    iconSize: 50,
                    icon: const Icon(Icons.skip_previous_sharp),
                    color: Colors.white,
                    onPressed: () async {
                      if (Getsong.player.hasPrevious) {
                        _isPlaying = true;
                        await Getsong.player.seekToPrevious();
                        await Getsong.player.play();
                      } else {
                        await Getsong.player.play();
                      }
                    },
                  ),
                  IconButton(
                    iconSize: 65,
                    icon: Icon(_isPlaying
                        ? Icons.pause_circle_filled_sharp
                        : Icons.play_circle_fill),
                    color: const Color.fromARGB(255, 109, 138, 240),
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) {
                          Getsong.player.pause();
                        } else {
                          Getsong.player.play();
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 50,
                    icon: const Icon(Icons.skip_next),
                    color: Colors.white,
                    onPressed: () async {
                      if (Getsong.player.hasNext) {
                        _isPlaying = true;
                        await Getsong.player.seekToNext();
                        await Getsong.player.play();
                      } else {
                        await Getsong.player.play();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        content: StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) => SizedBox(
            height: 100.0,
            child: Column(
              children: [
                Text(
                  '${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                Slider(
                  divisions: divisions,
                  min: min,
                  max: max,
                  value: snapshot.data ?? value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    Getsong.player.seek(duration);
  }

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          Getsong.player.positionStream,
          Getsong.player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  Widget _shuffleButton(BuildContext context, bool isEnabled) {
    return IconButton(
      icon: isEnabled
          ? Icon(
              Icons.shuffle,
              size: MediaQuery.of(context).size.width * 0.08,
              color: const Color.fromARGB(255, 109, 138, 240),
            )
          : Icon(
              Icons.shuffle,
              size: MediaQuery.of(context).size.width * 0.08,
              color: Colors.white,
            ),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await Getsong.player.shuffle();
        }
        await Getsong.player.setShuffleModeEnabled(enable);
      },
    );
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      Icon(
        Icons.repeat,
        size: MediaQuery.of(context).size.width * 0.08,
        color: Colors.white,
      ),
      Icon(
        Icons.repeat,
        size: MediaQuery.of(context).size.width * 0.08,
        color: const Color.fromARGB(255, 109, 138, 240),
      ),
      Icon(
        Icons.repeat_one,
        size: MediaQuery.of(context).size.width * 0.08,
        color: const Color.fromARGB(255, 109, 138, 240),
      ),
    ];
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        Getsong.player.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
