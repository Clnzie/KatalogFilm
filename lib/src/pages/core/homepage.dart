import 'dart:io';

import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieNowPlaying.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTopRateModelApi.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:Itil.Co/src/component/button.dart';
import 'package:Itil.Co/src/pages/core/movie_detail.dart';
import 'package:Itil.Co/src/pages/view-all/view_all_popular.dart';
import 'package:Itil.Co/src/pages/view-all/view_all_topRate.dart';
import 'package:Itil.Co/src/widgets/card_movie.dart';
import 'package:Itil.Co/src/widgets/carousel_widget.dart';
import 'package:Itil.Co/src/widgets/shimmer_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hidable/hidable.dart';
import 'package:http/retry.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ColorApp _colorApp = ColorApp();
  final TextStyleApp _textStyleApp = TextStyleApp();
  final HttpService httpService = HttpService();
  late Future<Movie> movie;
  late Future<MovieTopRated> movieTopRate;
  late Future<MovieNowPlaying> movieNowPlaying;
  ScrollController _controller = ScrollController();
  late FToast fToast;
  int exitCounter = 0;
  DateTime timeBackPress = DateTime.now();

  @override
  void initState() {
    super.initState();
    httpService.getMovieNowPlaying();
    movie = httpService.getMovie();
    movieTopRate = httpService.getMovieTopRate();
    movieNowPlaying = httpService.getMovieNowPlaying();
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
            preferredWidgetSize: Size.fromHeight(79),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to,",
                        style: _textStyleApp.textXL
                            .copyWith(color: _colorApp.textCol2),
                      ),
                      Image.asset(
                        "Assets/images/MovieCo.png",
                        width: 130,
                        height: 29,
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search_rounded),
                    color: _colorApp.primaryCol,
                    splashColor: const Color.fromARGB(255, 255, 255, 201),
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(_colorApp.tertiaryCol)),
                  )
                ],
              ),
            ),
          ),
          body: ListView(
            controller: _controller,
            // physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 24,
              ),

              //Slider Popular Movie
              FutureBuilder<Movie>(
                future: movie,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CarouselSlider.builder(
                        itemCount: 2,
                        itemBuilder: (context, index, realIndex) =>
                            Shimmer.fromColors(
                              baseColor: _colorApp.baseColShimmer,
                              highlightColor: _colorApp.highlightColShimmer,
                              child: Container(
                                // width: 50,
                                height: 240,
                                decoration: BoxDecoration(
                                    color: Color(0xff3a3a3a),
                                    borderRadius:
                                        BorderRadiusDirectional.circular(15)),
                              ),
                            ),
                        options: carouselOptions.copyWith(
                          autoPlay: false,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                        ));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return CarouselSlider.builder(
                      itemCount: snapshot.data!.results.length,
                      itemBuilder: (context, index, realIndex) {
                        List<int> genresIds =
                            snapshot.data!.results[index].genreIds;
                        return CachedNetworkImage(
                          imageUrl:
                              "${Constants.imagePath}${snapshot.data!.results[index].backdropPath}",
                          filterQuality: FilterQuality.high,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              width: double.infinity,
                              height: 240,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: imageProvider)),
                              child: Container(
                                width: double.infinity,
                                height: 240,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(16, 23, 23, 23),
                                          Color.fromARGB(255, 23, 23, 23)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${snapshot.data!.results[index].title}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: _textStyleApp.subHead2.copyWith(
                                            color: _colorApp.textCol2),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      SizedBox(
                                        height: 15,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: genresIds.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            int genreId = genresIds[index];
                                            String genreName =
                                                getGenreName(genreId);
                                            return Text(
                                              genreName + " ",
                                              style: _textStyleApp.textS
                                                  .copyWith(
                                                      color:
                                                          _colorApp.textCol2),
                                            );
                                          },
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MovieDetail(
                                                        movieID: snapshot.data!
                                                            .results[index].id),
                                              ));
                                        },
                                        label: Text(
                                          "Detail",
                                          style: _textStyleApp.textL.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: _colorApp.textCol3),
                                        ),
                                        icon: Icon(
                                          Icons.add_rounded,
                                          size: 24,
                                          color: _colorApp.primaryCol,
                                        ),
                                        style: elevatedButtonStyle.copyWith(
                                            minimumSize: WidgetStatePropertyAll(
                                                Size(77, 26)),
                                            padding: WidgetStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 10)),
                                            shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)))),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: _colorApp.baseColShimmer,
                            highlightColor: _colorApp.highlightColShimmer,
                            child: Container(
                              // width: 50,
                              height: 240,
                              decoration: BoxDecoration(
                                  color: Color(0xff3a3a3a),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red,
                            size: 24,
                          ),
                        );
                      },
                      options: carouselOptions,
                    );
                  }
                },
              ),
              SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Now Playing Movie",
                      style: _textStyleApp.subHead3.copyWith(
                        color: _colorApp.textCol2,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          print("asd");
                        },
                        child: Text(
                          "see all",
                          style: _textStyleApp.textS
                              .copyWith(color: _colorApp.textCol1),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),

              FutureBuilder<MovieNowPlaying>(
                future: movieNowPlaying,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 210,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            width: 110,
                            child: ShimmerCard(),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return SizedBox(
                      height: 210,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 6),
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
                                              snapshot.data!.results[index].id),
                                    ));
                                print("object 1");
                              },
                              imgPoster:
                                  "${Constants.imagePath}${snapshot.data!.results[index].posterPath}",
                              title: "${snapshot.data!.results[index].title}");
                        },
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Movie",
                      style: _textStyleApp.subHead3.copyWith(
                        color: _colorApp.textCol2,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          print("asd");
                        },
                        child: Text(
                          "see all",
                          style: _textStyleApp.textS
                              .copyWith(color: _colorApp.textCol1),
                        )),
                  ],
                ),
              ),
              FutureBuilder<Movie>(
                future: movie,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 210,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            width: 110,
                            child: ShimmerCard(),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 6),
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
                                              snapshot.data!.results[index].id),
                                    ));
                                print("object 2");
                              },
                              imgPoster:
                                  "${Constants.imagePath}${snapshot.data!.results[index].posterPath}",
                              title: "${snapshot.data!.results[index].title}");
                        },
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Rated Movie",
                      style: _textStyleApp.subHead3
                          .copyWith(color: _colorApp.textCol2),
                    ),
                    Text(
                      "see all",
                      style: _textStyleApp.textS
                          .copyWith(color: _colorApp.textCol1),
                    )
                  ],
                ),
              ),
              FutureBuilder<MovieTopRated>(
                future: movieTopRate,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 210,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            width: 110,
                            child: ShimmerCard(),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return SizedBox(
                      height: 210,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 6),
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
                                              snapshot.data!.results[index].id),
                                    ));
                                print("object 3");
                              },
                              imgPoster:
                                  "${Constants.imagePath}${snapshot.data!.results[index].posterPath}",
                              title: "${snapshot.data!.results[index].title}");
                        },
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 14,
              )
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

String getGenreName(int genreId) {
  Map<String, dynamic> genres = {
    "genres": [
      {"id": 28, "name": "Action"},
      {"id": 12, "name": "Adventure"},
      {"id": 16, "name": "Animation"},
      {"id": 35, "name": "Comedy"},
      {"id": 80, "name": "Crime"},
      {"id": 99, "name": "Documentary"},
      {"id": 18, "name": "Drama"},
      {"id": 10751, "name": "Family"},
      {"id": 14, "name": "Fantasy"},
      {"id": 36, "name": "History"},
      {"id": 27, "name": "Horror"},
      {"id": 10402, "name": "Music"},
      {"id": 9648, "name": "Mystery"},
      {"id": 10749, "name": "Romance"},
      {"id": 878, "name": "Science Fiction"},
      {"id": 10770, "name": "TV Movie"},
      {"id": 53, "name": "Thriller"},
      {"id": 10752, "name": "War"},
      {"id": 37, "name": "Western"}
    ]
  };

  String genreName = "";
  List<dynamic> genreList = genres['genres'];

  for (var genre in genreList) {
    if (genre['id'] == genreId) {
      genreName = genre['name'];
      break;
    }
  }

  return genreName;
}



 

//               //Popular
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Popular",
//                       style: _textStyleApp.subHead1.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: _colorApp.textCol2,
//                       ),
//                     ),
//                     TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewAllPopular(),
//                               ));
//                         },
//                         child: Text(
//                           "see more >",
//                           style: _textStyleApp.textL
//                               .copyWith(color: _colorApp.textCol1),
//                         ))
//                   ],
//                 ),
//               ),

//               //Movie Populer
//               FutureBuilder<Movie>(
//                 future: movie,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     // return Center(child: CircularProgressIndicator());
//                     return SizedBox(
//                       height: 171,
//                       child: ListView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         scrollDirection: Axis.horizontal,
//                         shrinkWrap: true,
//                         itemCount: 4,
//                         itemBuilder: (context, index) {
//                           return Shimmer.fromColors(
//                             baseColor: Color(0xff3a3a3a),
//                             highlightColor: Color.fromARGB(255, 92, 91, 91),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 4),
//                               width: 115,
//                               // height: 171,
//                               decoration: BoxDecoration(
//                                   color: Color(0xff3a3a3a),
//                                   borderRadius: BorderRadius.circular(15)),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Text("${snapshot.error}");
//                   } else {
//                     return SizedBox(
//                       height: 171,
//                       child: ListView.builder(
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         physics: BouncingScrollPhysics(),
//                         scrollDirection: Axis.horizontal,
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.results.length,
//                         itemBuilder: (context, index) {
//                           return CardMovie(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => MovieDetail(
//                                       movieID: snapshot.data!.results[index].id,
//                                     ),
//                                   ));
//                             },
//                             imgPoster:
//                                 "${Constants.imagePath}${snapshot.data!.results[index].posterPath}",
//                             title: "${snapshot.data!.results[index].title}",
//                           );
//                         },
//                       ),
//                     );
//                   }
//                 },
//               ),

//               //Trailers
//               Stack(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(top: 14),
//                     width: double.infinity,
//                     height: 255,
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 32, 32, 32),
//                       // image: DecorationImage(
//                       //     fit: BoxFit.cover,
//                       //     filterQuality: FilterQuality.high,
//                       //     image: AssetImage('lib/Assets/morales.jpeg')),
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 14),
//                     margin: EdgeInsets.only(top: 14),
//                     width: double.infinity,
//                     height: 255,
//                     color: Color.fromARGB(129, 0, 0, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                           child: Text(
//                             "Trailers",
//                             style: _textStyleApp.subHead1.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: _colorApp.textCol2),
//                           ),
//                         ),

//                         //Video Trailers
//                         FutureBuilder<Movie>(
//                           future: movie,
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               //Shimmer Trailers
//                               return SizedBox(
//                                 height: 190,
//                                 child: ListView.builder(
//                                   padding: EdgeInsets.symmetric(horizontal: 8),
//                                   physics: NeverScrollableScrollPhysics(),
//                                   scrollDirection: Axis.horizontal,
//                                   shrinkWrap: true,
//                                   itemCount: 4,
//                                   itemBuilder: (context, index) {
//                                     return Shimmer.fromColors(
//                                         baseColor: Color(0xff3a3a3a),
//                                         highlightColor:
//                                             Color.fromARGB(255, 92, 91, 91),
//                                         child: Container(
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 4),
//                                           width: 290,
//                                           decoration: BoxDecoration(
//                                               color: Color(0xff3a3a3a),
//                                               borderRadius:
//                                                   BorderRadius.circular(15)),
//                                         ));
//                                   },
//                                 ),
//                               );
//                             } else if (snapshot.hasError) {
//                               return Text("${snapshot.error}");
//                             } else {
//                               return SizedBox(
//                                 height: 190,
//                                 child: ListView.builder(
//                                   padding: EdgeInsets.symmetric(horizontal: 8),
//                                   scrollDirection: Axis.horizontal,
//                                   physics: BouncingScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemCount: 6,
//                                   itemBuilder: (context, index) {
//                                     return CachedNetworkImage(
//                                       imageUrl:
//                                           "${Constants.imagePath}${snapshot.data!.results[index].backdropPath}",
//                                       imageBuilder: (context, imageProvider) {
//                                         return Container(
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 4),
//                                           // height: 159,
//                                           width: 290,
//                                           decoration: BoxDecoration(
//                                               // color: Color.fromARGB(
//                                               //     185, 24, 24, 24),
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                               image: DecorationImage(
//                                                   fit: BoxFit.fitHeight,
//                                                   filterQuality:
//                                                       FilterQuality.high,
//                                                   image: imageProvider)),
//                                         );
//                                       },
//                                       placeholder: (context, url) =>
//                                           Shimmer.fromColors(
//                                         baseColor: Color(0xff3a3a3a),
//                                         highlightColor:
//                                             Color.fromARGB(255, 92, 91, 91),
//                                         child: Container(
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 4),
//                                           width: 290,
//                                           decoration: BoxDecoration(
//                                               color: Color(0xff3a3a3a),
//                                               borderRadius:
//                                                   BorderRadius.circular(15)),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               //Top Rated
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Top Rated",
//                       style: _textStyleApp.subHead1.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: _colorApp.textCol2),
//                     ),
//                     TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewAllToprate(),
//                               ));
//                         },
//                         child: Text(
//                           "see more >",
//                           style: _textStyleApp.textL
//                               .copyWith(color: _colorApp.textCol1),
//                         ))
//                   ],
//                 ),
//               ),

//               // Movie Top Rated
//               FutureBuilder<MovieTopRated>(
//                 future: movieTopRate,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     // return Center(child: CircularProgressIndicator());
//                     return SizedBox(
//                       height: 171,
//                       child: ListView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         scrollDirection: Axis.horizontal,
//                         shrinkWrap: true,
//                         itemCount: 4,
//                         itemBuilder: (context, index) {
//                           return Shimmer.fromColors(
//                             baseColor: Color(0xff3a3a3a),
//                             highlightColor: Color.fromARGB(255, 92, 91, 91),
//                             child: Container(
//                               margin: EdgeInsets.symmetric(horizontal: 4),
//                               width: 115,
//                               // height: 171,
//                               decoration: BoxDecoration(
//                                   color: Color(0xff3a3a3a),
//                                   borderRadius: BorderRadius.circular(15)),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Text("${snapshot.error}");
//                   } else {
//                     return SizedBox(
//                       height: 171,
//                       child: ListView.builder(
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         physics: BouncingScrollPhysics(),
//                         scrollDirection: Axis.horizontal,
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.results.length,
//                         itemBuilder: (context, index) {
//                           return CardMovie(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => MovieDetail(
//                                       movieID: snapshot.data!.results[index].id,
//                                     ),
//                                   ));
//                             },
//                             imgPoster:
//                                 "${Constants.imagePath}${snapshot.data!.results[index].posterPath}",
//                             title: "${snapshot.data!.results[index].title}",
//                           );
//                         },
//                       ),
//                     );
//                   }
//                 },
//               ),

//               SizedBox(
//                 height: 14,
//               ),
