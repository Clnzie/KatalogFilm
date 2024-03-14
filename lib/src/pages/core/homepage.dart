import 'dart:io';

import 'package:Itil.Co/0/example.dart';
import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTopRateModelApi.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:Itil.Co/src/component/button.dart';
import 'package:Itil.Co/src/pages/core/movie-detail.dart';
import 'package:Itil.Co/src/pages/view-all/view-all-popular.dart';
import 'package:Itil.Co/src/pages/view-all/view-all-topRate.dart';
import 'package:Itil.Co/src/widgets/card-movie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hidable/hidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Movie> movie;
  late Future<MovieTopRate> movieTopRate;
  ScrollController _controller = ScrollController();
  late FToast fToast;
  int exitCounter = 0;

  @override
  void initState() {
    super.initState();
    movie = getMovie();
    movieTopRate = getMovieTopRate();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        exitCounter++;
        if (exitCounter == 1) {
          return _exitToast();
        } else if (exitCounter == 2) {
          return exit(0);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: Hidable(
            controller: _controller,
            child: PreferredSize(
                preferredSize: Size(double.infinity, 42),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 150,
                    // height: 90,
                    decoration: BoxDecoration(
                        // color: Colors.red,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            image: AssetImage("lib/Assets/MovieCo.png"))),
                  ),
                )),
          ),
          backgroundColor: Color(0xff171717),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 4,
              ),
              //Slider Popular Movie
              FutureBuilder<Movie>(
                future: movie,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider.builder(
                      itemCount: snapshot.data!.results.length,
                      itemBuilder: (context, index, realIndex) {
                        return Stack(
                          children: [
                            Container(
                              // margin: EdgeInsets.symmetric(horizontal: 1.5),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(142, 198, 198, 198),
                                  // borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                      image: NetworkImage(
                                          "${Constants.imagePath}${snapshot.data!.results[index].backdropPath}"))),
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    Color.fromARGB(33, 0, 0, 0),
                                    Color.fromARGB(237, 0, 0, 0),
                                  ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: SizedBox(
                                  width: 250,
                                  child: Text(
                                    "${snapshot.data!.results[index].title}",
                                    style: subHead2.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: textCol2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                          aspectRatio: 24 / 12,
                          height: 240,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 750)),
                    );
                  }
                  return SizedBox();
                },
              ),
              //Movie Populer
              FutureBuilder<Movie>(
                future: movie,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Populer",
                                style: subHead1.copyWith(color: textCol2),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewAllPopular(
                                            data: snapshot.data!),
                                      ));
                                },
                                child: Icon(
                                  Icons.library_books_outlined,
                                  size: 24,
                                  color: textCol1,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                          height: 171,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.results.length,
                            itemBuilder: (context, index) {
                              return CardMovie(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetail(
                                            title:
                                                "${snapshot.data!.results[index].title}",
                                            originalTitle:
                                                "${snapshot.data!.results[index].originalTitle}",
                                            backdrop_path:
                                                "${snapshot.data!.results[index].backdropPath}",
                                            overview:
                                                "${snapshot.data!.results[index].overview}",
                                            poster_path:
                                                "${snapshot.data!.results[index].posterPath}",
                                            release_date:
                                                "${snapshot.data!.results[index].releaseDate}",
                                            vote_average: snapshot.data!
                                                .results[index].voteAverage
                                                .toString(),
                                            vote_count: snapshot
                                                .data!.results[index].voteCount
                                                .toString(),
                                            popularity: snapshot
                                                .data!.results[index].popularity
                                                .toString(),
                                            language:
                                                "${snapshot.data!.results[index].originalLanguage}"),
                                      ));
                                },
                                imgPoster:
                                    "${Constants.imagePath}${snapshot.data!.results[index].posterPath}",
                                title: "${snapshot.data!.results[index].title}",
                              );
                            },
                          ),
                        )
                      ],
                    );
                  }
                  return SizedBox();
                },
              ),
              SizedBox(
                height: 14,
              ),
              //Trailers
              FutureBuilder<Movie>(
                future: movie,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: double.infinity,
                      // height: 240,
                      decoration: BoxDecoration(
                          color: primaryCol,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: AssetImage('lib/Assets/morales.jpeg'))),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 255,
                            color: Color.fromARGB(129, 0, 0, 0),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    "Trailers",
                                    style: subHead2.copyWith(color: textCol2),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  height: 190,
                                  child: ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 6,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        // height: 159,
                                        width: 290,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(185, 24, 24, 24),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                fit: BoxFit.fitHeight,
                                                filterQuality:
                                                    FilterQuality.high,
                                                image: NetworkImage(
                                                    "${Constants.imagePath}${snapshot.data!.results[index].backdropPath}"))),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
              //Top Rated
              FutureBuilder<MovieTopRate>(
                future: movieTopRate,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Top Rated",
                                style: subHead1.copyWith(color: textCol2),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewAllToprate(
                                            data: snapshot.data!),
                                      ));
                                },
                                child: Icon(
                                  Icons.library_books_outlined,
                                  size: 24,
                                  color: textCol1,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                          height: 171,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.results?.length,
                            itemBuilder: (context, index) {
                              return CardMovie(
                                onTap: () {},
                                imgPoster:
                                    "${Constants.imagePath}${snapshot.data!.results?[index].posterPath}",
                                title:
                                    "${snapshot.data!.results?[index].title}",
                              );
                            },
                          ),
                        )
                      ],
                    );
                  }
                  return SizedBox();
                },
              ),
              SizedBox(
                height: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Toast Exit
  _exitToast() {
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

//Useless
Future<bool?> _dialogExit(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: secondaryCol,
        iconColor: secondaryCol,
        iconPadding: EdgeInsets.symmetric(vertical: 18),
        icon: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: textCol1,
                border: Border.all(color: textCol2, width: 2)),
            child: Icon(
              Icons.notification_important_rounded,
              size: 35,
            )),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        contentTextStyle:
            textXL.copyWith(color: textCol2, fontWeight: FontWeight.w600),
        content: Text(
          "Are you sure exit App??",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.symmetric(vertical: 18),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
            style: elevatedButtonStyle.copyWith(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
                textStyle: MaterialStatePropertyAll(
                  textXL.copyWith(color: textCol2),
                ),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
                minimumSize: MaterialStatePropertyAll(Size(100, 48))),
          ),
          ElevatedButton(
            onPressed: () => exit(0),
            child: Text("Exit"),
            style: elevatedButtonStyle.copyWith(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
                textStyle: MaterialStatePropertyAll(
                  textXL.copyWith(color: textCol2),
                ),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
                minimumSize: MaterialStatePropertyAll(Size(100, 48))),
          ),
        ],
      );
    },
  );
}
