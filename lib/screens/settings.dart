import 'package:flutter/material.dart';
import 'package:musicapp/db/playlist_db.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, false),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 27),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color.fromARGB(255, 109, 138, 240),
                  ),
                  height: 50,
                  width: 50,
                  child: const Icon(
                    Icons.share,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  await Share.share('link');
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color.fromARGB(255, 109, 138, 240),
                  ),
                  height: 50,
                  width: 50,
                  child: const Icon(
                    Icons.feedback_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  'Feed Back',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  if (await launch('mailto:amalsubru@gmail.com')) {
                    throw "Try Again";
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color.fromARGB(255, 109, 138, 240),
                  ),
                  height: 50,
                  width: 50,
                  child: const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  'About Developer',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  _launchUrl();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color.fromARGB(255, 109, 138, 240),
                  ),
                  height: 50,
                  width: 50,
                  child: const Icon(
                    Icons.restore,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: const Text(
                  'Reset App',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Reset App'),
                          content: const Text(
                              'Are you sure you want to Reset App ?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                appReset(context);
                                // Restart(context);
                                Restart.restartApp();
                                // Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              const Text(
                'v.1.0.0',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  final Uri _url = Uri.parse('https://amalsubrahmanyan.github.io/PORTFOLIO/');
}
