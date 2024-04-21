import 'dart:io';

import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieModelApi.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Example extends StatefulWidget {
  static String videoID = 'QslJYDX3o8s';
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late Future<Movie> movie;
  late FToast fToast;
  int exitCounter = 0;
  late final YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: "QslJYDX3o8s",
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ));
  List<String> image = [
    'https://i.pinimg.com/originals/08/47/1f/08471f353ddc3fd59765ffa9793654a9.jpg',
    'https://i.pinimg.com/originals/14/58/2e/14582ec257e25330f2c6181928b87259.jpg',
    'https://i.pinimg.com/originals/63/f7/d1/63f7d1274fa99b970ce00137be1bd749.png',
    'https://i.pinimg.com/originals/74/af/58/74af58f727597fabc04d2018c5e2e150.jpg',
    'https://i.pinimg.com/originals/ad/d2/82/add282fa437ffc41ac18a21b275a13ed.jpg',
  ];

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    movie = getMovie();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: YoutubePlayer(controller: _controller),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: image.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: image[index],
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                                image: DecorationImage(
                                  image: imageProvider,
                                ),
                              ),
                            );
                          },
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Color(0xff3a3a3a),
                            highlightColor: Color.fromARGB(255, 92, 91, 91),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff3a3a3a),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          children: [
                            Text(
                              "data",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                            Text(
                              "data",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _popUpExit() {
    Widget toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
          color: textCol2, borderRadius: BorderRadius.circular(12)),
      child: Text(
        "Press again to exit",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      fadeDuration: Duration(milliseconds: 250),
      toastDuration: Duration(seconds: 2),
    );
  }
}
