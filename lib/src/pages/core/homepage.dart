import 'dart:io';

import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTopRateModelApi.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:Itil.Co/src/pages/core/movie-detail.dart';
import 'package:Itil.Co/src/pages/view-all/view-all-popular.dart';
import 'package:Itil.Co/src/pages/view-all/view-all-topRate.dart';
import 'package:Itil.Co/src/widgets/card-movie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hidable/hidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Movie> movie;
  late Future<MovieTopRated> movieTopRate;
  ScrollController _controller = ScrollController();
  late FToast fToast;
  int exitCounter = 0;
  DateTime timeBackPress = DateTime.now();

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
        final diff = DateTime.now().difference(timeBackPress);
        final isExitingWarning = diff >= Duration(seconds: 2);
        timeBackPress = DateTime.now();
        if (isExitingWarning) {
          return _exitToast();
        } else {
          return exit(0);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xff171717),
          //APP BAR
          appBar: Hidable(
            controller: _controller,
            child: PreferredSize(
                preferredSize: Size(double.infinity, 42),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            filterQuality: FilterQuality.high,
                            image: AssetImage("lib/Assets/MovieCo.png"))),
                  ),
                )),
          ),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Color(0xff3a3a3a),
                      highlightColor: Color.fromARGB(255, 92, 91, 91),
                      child: Container(
                        // width: 50,
                        height: 240,
                        color: Color(0xff3a3a3a),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return CarouselSlider.builder(
                      itemCount: snapshot.data!.results.length,
                      itemBuilder: (context, index, realIndex) {
                        return CachedNetworkImage(
                          imageUrl:
                              "${Constants.imagePath}${snapshot.data!.results[index].backdropPath}",
                          filterQuality: FilterQuality.high,
                          imageBuilder: (context, imageProvider) {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: imageProvider)),
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
                                )
                              ],
                            );
                          },
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Color(0xff3a3a3a),
                            highlightColor: Color.fromARGB(255, 92, 91, 91),
                            child: Container(
                              // width: 50,
                              height: 240,
                              color: Color(0xff3a3a3a),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red,
                            size: 24,
                          ),
                        );
                      },
                      options: CarouselOptions(
                          // aspectRatio: 16 / 9,
                          height: 240,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 750)),
                    );
                  }
                },
              ),

              //Popular
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Populer",
                      style: subHead1.copyWith(color: textCol2),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("object");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewAllPopular(),
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

              //Movie Populer
              FutureBuilder<Movie>(
                future: movie,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return Center(child: CircularProgressIndicator());
                    return SizedBox(
                      height: 171,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Color(0xff3a3a3a),
                            highlightColor: Color.fromARGB(255, 92, 91, 91),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: 115,
                              // height: 171,
                              decoration: BoxDecoration(
                                  color: Color(0xff3a3a3a),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return SizedBox(
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
                                        movieID:
                                            snapshot.data!.results[index].id,
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
                                        vote_average: snapshot
                                            .data!.results[index].voteAverage
                                            .toString(),
                                        vote_count: snapshot
                                            .data!.results[index].voteCount
                                            .toString(),
                                        popularity: snapshot
                                            .data!.results[index].popularity
                                            .toString(),
                                        language:
                                            "${snapshot.data!.results[index].originalLanguage}",
                                        genre: snapshot
                                            .data!.results[index].genreIds),
                                  ));
                            },
                            imgPoster:
                                "${Constants.imagePath}${snapshot.data!.results[index].posterPath}",
                            title: "${snapshot.data!.results[index].title}",
                          );
                        },
                      ),
                    );
                  }
                },
              ),

              //Trailers
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 14),
                    width: double.infinity,
                    height: 255,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 32, 32, 32),
                      // image: DecorationImage(
                      //     fit: BoxFit.cover,
                      //     filterQuality: FilterQuality.high,
                      //     image: AssetImage('lib/Assets/morales.jpeg')),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    margin: EdgeInsets.only(top: 14),
                    width: double.infinity,
                    height: 255,
                    color: Color.fromARGB(129, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "Trailers",
                            style: subHead2.copyWith(color: textCol2),
                          ),
                        ),

                        //Video Trailers
                        FutureBuilder<Movie>(
                          future: movie,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              //Shimmer Trailers
                              return SizedBox(
                                height: 190,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                        baseColor: Color(0xff3a3a3a),
                                        highlightColor:
                                            Color.fromARGB(255, 92, 91, 91),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          width: 290,
                                          decoration: BoxDecoration(
                                              color: Color(0xff3a3a3a),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ));
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else {
                              return SizedBox(
                                height: 190,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 6,
                                  itemBuilder: (context, index) {
                                    return CachedNetworkImage(
                                      imageUrl:
                                          "${Constants.imagePath}${snapshot.data!.results[index].backdropPath}",
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          // height: 159,
                                          width: 290,
                                          decoration: BoxDecoration(
                                              // color: Color.fromARGB(
                                              //     185, 24, 24, 24),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  fit: BoxFit.fitHeight,
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  image: imageProvider)),
                                        );
                                      },
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Color(0xff3a3a3a),
                                        highlightColor:
                                            Color.fromARGB(255, 92, 91, 91),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          width: 290,
                                          decoration: BoxDecoration(
                                              color: Color(0xff3a3a3a),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),

              //Top Rated
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
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
                              builder: (context) => ViewAllToprate(),
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

              // Movie Top Rated
              FutureBuilder<MovieTopRated>(
                future: movieTopRate,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return Center(child: CircularProgressIndicator());
                    return SizedBox(
                      height: 171,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Color(0xff3a3a3a),
                            highlightColor: Color.fromARGB(255, 92, 91, 91),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: 115,
                              // height: 171,
                              decoration: BoxDecoration(
                                  color: Color(0xff3a3a3a),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return SizedBox(
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
                                        movieID:
                                            snapshot.data!.results[index].id,
                                        title:
                                            snapshot.data!.results[index].title,
                                        originalTitle: snapshot
                                            .data!.results[index].originalTitle,
                                        backdrop_path: snapshot
                                            .data!.results[index].backdropPath,
                                        overview: snapshot
                                            .data!.results[index].overview,
                                        poster_path: snapshot
                                            .data!.results[index].posterPath,
                                        release_date: snapshot
                                            .data!.results[index].releaseDate,
                                        vote_average: snapshot
                                            .data!.results[index].voteAverage
                                            .toString(),
                                        vote_count: snapshot
                                            .data!.results[index].voteCount
                                            .toString(),
                                        popularity: snapshot
                                            .data!.results[index].popularity
                                            .toString(),
                                        language: snapshot.data!.results[index]
                                            .originalLanguage,
                                        genre: snapshot
                                            .data?.results[index].genreIds),
                                  ));
                            },
                            imgPoster:
                                "${Constants.imagePath}${snapshot.data!.results[index].posterPath}",
                            title: "${snapshot.data!.results[index].title}",
                          );
                        },
                      ),
                    );
                  }
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
