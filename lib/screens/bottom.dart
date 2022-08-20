// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicapp/db/favoritedb.dart';
import 'package:musicapp/db/playlist_db.dart';
import 'package:musicapp/screens/favorite.dart';
import 'package:musicapp/screens/glass.dart';
import 'package:musicapp/screens/homescreen.dart';
import 'package:musicapp/screens/miniplayer.dart';
import 'package:musicapp/screens/next.dart';
import 'package:musicapp/screens/playlist.dart';
import 'package:musicapp/screens/searchscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selected = 0;
  List<Widget> pages = <Widget>[
    const HomeScreen(),
    const Favorite(),
    const PlayList(),
    const SearchScreen(),
  ];

  void _onItemClick(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selected],
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: refreshNotifier,
          builder: (BuildContext context, bool music, Widget? child) {
            return SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (Getsong.player.currentIndex != null)
                  Column(
                    children: const [
                      GlassMorphism(
                          start: 0.1, end: 0.5, radius: 0, child: MiniPlayer()),
                      SizedBox(height: 10),
                    ],
                  )
                else
                  const SizedBox(),
                BottomNavigationBar(
                  backgroundColor: Colors.black,
                  unselectedItemColor: const Color.fromARGB(255, 109, 138, 240),
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: FaIcon(
                        FontAwesomeIcons.houseFire,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                        icon: FaIcon(
                          FontAwesomeIcons.solidHeart,
                        ),
                        label: 'Favorite'),
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.queue_music_sharp,
                        ),
                        label: 'Plyalist'),
                    BottomNavigationBarItem(
                        icon: FaIcon(
                          // ignore: deprecated_member_use
                          FontAwesomeIcons.search,
                        ),
                        label: 'Search'),
                  ],
                  currentIndex: _selected,
                  selectedItemColor: Colors.white,
                  onTap: _onItemClick,
                  selectedIconTheme: const IconThemeData(size: 25),
                ),
              ]),
            );
          }),
    );
  }
}
