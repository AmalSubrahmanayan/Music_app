import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musicapp/screens/homescreen.dart';
import 'package:musicapp/screens/next.dart';
import 'package:musicapp/screens/playscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<SongModel>> searchList = ValueNotifier([]);

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        // ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 245, 242, 244),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: 'Search',
                    suffixIcon: Icon(Icons.search, color: Colors.black)),
                onChanged: (String? value) {
                  if (value != null && value.isNotEmpty) {
                    searchList.value.clear();
                    for (SongModel item in HomeScreen.song) {
                      if (item.title
                          .toLowerCase()
                          .contains(value.toLowerCase())) {
                        searchList.value.add(item);
                      }
                    }
                  }
                  searchList.notifyListeners();
                },
              ),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: searchList,
                    builder: (BuildContext context, List<SongModel> songData,
                        Widget? child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: songData.isEmpty
                            ? Center(
                                child: Lottie.asset(
                                'assets/images/search.json',
                                height: 300,
                                width: 300,
                              ))
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  final data = songData[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: ListTile(
                                      leading: Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 109, 138, 230),
                                          borderRadius:
                                              BorderRadius.circular(09),
                                        ),
                                        child: QueryArtworkWidget(
                                            artworkBorder:
                                                BorderRadius.circular(9),
                                            nullArtworkWidget: const Icon(
                                              Icons.music_note_outlined,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                            artworkFit: BoxFit.cover,
                                            id: data.id,
                                            type: ArtworkType.AUDIO),
                                      ),
                                      title: Text(
                                        data.title,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      onTap: () {
                                        final searchIndex =
                                            creatSearchIndex(data);
                                        FocusScope.of(context).unfocus();
                                        Getsong.player.setAudioSource(
                                            Getsong.createSongList(
                                                HomeScreen.song),
                                            initialIndex: searchIndex);
                                        Getsong.player.play();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (ctx) => PlayScreen(
                                                    playerSong:
                                                        HomeScreen.song)));
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (ctx, index) {
                                  return const Divider();
                                },
                                itemCount: searchList.value.length),
                      );
                    }),
              ),
            ],
          ),
        ));
  }

  int? creatSearchIndex(SongModel data) {
    for (int i = 0; i < HomeScreen.song.length; i++) {
      if (data.id == HomeScreen.song[i].id) {
        return i;
      }
    }
    return null;
  }
}
