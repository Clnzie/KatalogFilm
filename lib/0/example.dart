import 'package:Itil.Co/0/asd.dart';
import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieDetailModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieModelApi.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:Itil.Co/src/widgets/carousel_widget.dart';
import 'package:Itil.Co/src/widgets/shimmer_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

class Example extends StatefulWidget {
  static String videoID = 'QslJYDX3o8s';
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final ColorApp _colorApp = ColorApp();
  final TextStyleApp _textStyleApp = TextStyleApp();
  final HttpService httpService = HttpService();
  late FToast fToast;
  int exitCounter = 0;
  late Future<Movie> movie;
  // late final YoutubePlayerController _controller = YoutubePlayerController(
  //     initialVideoId: "QslJYDX3o8s",
  //     flags: YoutubePlayerFlags(
  //       autoPlay: false,
  //     ));
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
    movie = httpService.getMovie();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            ShimmerCard(),
          ],
        ),
      ),
    );
  }

  _popUpExit() {
    Widget toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
          color: _colorApp.textCol2, borderRadius: BorderRadius.circular(12)),
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
