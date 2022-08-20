import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/screens/animatedtext.dart';
import 'package:musicapp/screens/next.dart';
import 'package:musicapp/screens/playscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    Getsong.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // color: Colors.transparent,
      color: Colors.white,

      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 60,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayScreen(
                playerSong: Getsong.playingSong,
              ),
            ),
          );
        },
        iconColor: Colors.black,
        textColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: QueryArtworkWidget(
              artworkQuality: FilterQuality.high,
              artworkFit: BoxFit.fill,
              artworkBorder: BorderRadius.circular(30),
              nullArtworkWidget: Lottie.asset('assets/images/play.json'),
              id: Getsong.playingSong[Getsong.player.currentIndex!].id,
              type: ArtworkType.AUDIO,
            ),
          ),
        ),
        title: AnimatedText(
          text: Getsong
              .playingSong[Getsong.player.currentIndex!].displayNameWOExt,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            "${Getsong.playingSong[Getsong.player.currentIndex!].artist}",
            style:
                const TextStyle(fontSize: 11, overflow: TextOverflow.ellipsis),
          ),
        ),
        trailing: FittedBox(
          fit: BoxFit.fill,
          child: Row(
            children: [
              IconButton(
                  onPressed: () async {
                    if (Getsong.player.hasPrevious) {
                      await Getsong.player.seekToPrevious();
                      await Getsong.player.play();
                    } else {
                      await Getsong.player.play();
                    }
                  },
                  icon: const Icon(
                    Icons.skip_previous,
                    size: 35,
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    primary: Colors.black,
                    onPrimary: Colors.white),
                onPressed: () async {
                  if (Getsong.player.playing) {
                    await Getsong.player.pause();
                    setState(() {});
                  } else {
                    await Getsong.player.play();
                    setState(() {});
                  }
                },
                child: StreamBuilder<bool>(
                  stream: Getsong.player.playingStream,
                  builder: (context, snapshot) {
                    bool? playingStage = snapshot.data;
                    if (playingStage != null && playingStage) {
                      return const Icon(
                        Icons.pause_circle_outline,
                        size: 35,
                      );
                    } else {
                      return const Icon(
                        Icons.play_circle_outline,
                        size: 35,
                      );
                    }
                  },
                ),
              ),
              IconButton(
                  onPressed: (() async {
                    if (Getsong.player.hasNext) {
                      await Getsong.player.seekToNext();
                      await Getsong.player.play();
                    } else {
                      await Getsong.player.play();
                    }
                  }),
                  icon: const Icon(
                    Icons.skip_next,
                    size: 35,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
