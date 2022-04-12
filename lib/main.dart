import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leaningflutter/constants.dart';
import 'package:http/http.dart' as http;
import 'package:leaningflutter/models/chewie_item.dart';
import 'package:leaningflutter/models/mediaModel.dart';
import 'package:leaningflutter/models/storyModel.dart';
import 'package:leaningflutter/screens/login.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Story> stories = [];

  List<Media> medias = [];

  String? _userId;

  Future<List<Story>> getStories({bool refresh = false}) async {
    if (stories.isNotEmpty && _userId != '') return stories;
    final response = await http.post(
        Uri.parse('https://hpvbot.herokuapp.com/api-get-stories'),
        body: {'s_id': '1688271345%3Azj3YXWjGJC1Bc9%3A14'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      stories = [];
      for (Map<String, dynamic> i in data) {
        stories.add(Story.fromJson(i));
      }
    }
    return stories;
  }

  Future<List<Media>> getStoryMedias() async {
    if (_userId == null) return [];
    medias = [];
    final response = await http.post(
        Uri.parse('https://hpvbot.herokuapp.com/api-stories'),
        body: {'s_id': '1688271345%3Azj3YXWjGJC1Bc9%3A14', 'user_id': _userId});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      for (Map<String, dynamic> i in data) {
        medias.add(Media.fromJson(i));
      }
      return medias;
    } else {
      return [];
    }
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _userId = '';
    });
    // await getStories(refresh: true);
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('HoaiPV Bot'),
        //   backgroundColor: primaryColor,
        // ),
        backgroundColor: Color(0XFF071828),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
                    child: FutureBuilder(
                      future: getStories(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: CircularProgressIndicator(
                                color: primaryColor, strokeWidth: 2),
                          );
                        } else {
                          return Row(
                              children: stories
                                  .map((story) => InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _userId = story.id;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Container(
                                            width: 68,
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: story.id ==
                                                          _userId
                                                      ? Colors.red
                                                      : story.seen == null
                                                          ? primaryColor
                                                          : Color(0XFF8C8C8C),
                                                  radius: 30,
                                                  child: CircleAvatar(
                                                    radius: 28,
                                                    backgroundColor:
                                                        primaryColor,
                                                    backgroundImage:
                                                        NetworkImage(story
                                                                .profilePicUrl ??
                                                            ""),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  child: Text(
                                                    story.username ?? "",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: primaryColor,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList());
                        }
                      },
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: getStoryMedias(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: CircularProgressIndicator(
                                    color: primaryColor, strokeWidth: 3),
                              );
                            } else {
                              if (medias.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: SvgPicture.asset(
                                            'assets/images/instagram.svg'),
                                      ),
                                      Text(
                                        'Instagram Story',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Courier',
                                            color: primaryColor),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Column(
                                    children: medias
                                        .map((media) => media.isVideo != null &&
                                                media.isVideo == true
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Container(
                                                  height: (852 - 252) *
                                                      (480 /
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                        color: primaryColor,
                                                        width: 2,
                                                      )),
                                                  child: ChewieItem(
                                                    videoPlayerController:
                                                        VideoPlayerController
                                                            .network(
                                                                media.url ??
                                                                    ''),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                        color: primaryColor,
                                                        width: 2,
                                                      )),
                                                  child: Image.network(
                                                      media.url ?? ''),
                                                ),
                                              ))
                                        .toList());
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
