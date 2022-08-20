import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Getsong {
  static AudioPlayer player = AudioPlayer();
  int currentIndes = 0;
  static List<SongModel> songCopy = [];
  static List<SongModel> playingSong = [];

  // ignore: prefer_typing_uninitialized_variables
  static var songscopy;
  static ConcatenatingAudioSource createSongList(List<SongModel> songs) {
    List<AudioSource> sources = [];
    playingSong = songs;
    for (var song in songs) {
      sources.add(
        AudioSource.uri(Uri.parse(song.uri!),
            tag: MediaItem(
                id: song.id.toString(),
                title: song.title,
                album: song.album,
                artist: song.album)),
      );
    }
    return ConcatenatingAudioSource(children: sources);
  }
}
