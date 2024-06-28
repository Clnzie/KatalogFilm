import 'dart:convert';
import 'dart:io';

import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieCreditsModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTrailerModelApi.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class MovieDetail extends StatefulWidget {
  final int movieID;

  const MovieDetail({
    super.key,
    required this.movieID,
  });

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  List<MovieTrailerList> _list = [];
  final ColorApp _colorApp = ColorApp();
  final TextStyleApp _textStyleApp = TextStyleApp();
  final HttpService _httpService = HttpService();

  // getData() async {
  //   List<MovieTrailerList?> listMovie =
  //       await _httpService.getMovieTrailerList(widget.movieID.toString());
  //   _list = listMovie;
  // print(listMovie);
  // }

  // late final YoutubePlayerController _controller = YoutubePlayerController(
  //   initialVideoId: "QslJYDX3o8s",
  //   flags: YoutubePlayerFlags(
  //     autoPlay: false,
  //   ),
  // );
  Future<void> getMovieTrailerList() async {
    final String url =
        "https://api.themoviedb.org/3/movie/${widget.movieID}/videos?api_key=b0b1b7542963befc2f848ce363e5c4ab";

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseDecode = jsonDecode(response.body);
      final List<dynamic> responseData = responseDecode["results"];
      // print("asdasda ${responseData} asdasdas");
      setState(() {
        _list = responseData.map((e) => MovieTrailerList.fromJson(e)).toList();
      });
    } else {
      throw Exception("Error to load Data");
    }
  }

  @override
  void initState() {
    getMovieTrailerList();
    // _httpService.getMovieTrailerList(widget.movieID.toString());
    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: _httpService.getDetailMovie(widget.movieID.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Stack(
                children: [
                  ListView(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "${Constants.imagePath}${snapshot.data!.posterPath}",
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 1.40,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fill,
                                    image: imageProvider)),
                            child: Transform.translate(
                              offset: Offset(0, 20),
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height / 1.40,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          _colorApp.primaryCol.withOpacity(0),
                                          _colorApp.primaryCol
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.5, 0.95])),
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) => Icon(
                          Icons.error_outline_rounded,
                          size: 24,
                          color: Colors.red,
                        ),
                      ),

                      // Image(
                      //   image: NetworkImage(
                      //       "${Constants.imagePath}${snapshot.data!.posterPath}"),
                      //   filterQuality: FilterQuality.high,
                      //   width: double.infinity,
                      //   height: MediaQuery.of(context).size.height / 2,
                      // ),
                      Container(
                        width: double.infinity,
                        color: _colorApp.primaryCol,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: _colorApp.tertiaryCol,
                                    size: 24,
                                  ),
                                  Text(
                                    snapshot.data!.voteAverage
                                        .toString()
                                        .substring(0, 3),
                                    style: _textStyleApp.subHead3.copyWith(
                                        color: _colorApp.textCol1,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Text(
                                    "(${snapshot.data!.popularity}" +
                                        " " +
                                        "popularity)",
                                    style: _textStyleApp.textL.copyWith(
                                        color: _colorApp.textCol2,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "${snapshot.data!.title}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: _textStyleApp.headLines3.copyWith(
                                  color: _colorApp.textCol2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              height: 30,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.genres!.length,
                                itemBuilder: (context, index) {
                                  final genres = snapshot.data!.genres![index];
                                  return Container(
                                    margin: EdgeInsets.only(left: 8),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _colorApp.secondaryCol,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        genres.name.toString(),
                                        style: _textStyleApp.textL.copyWith(
                                            color: _colorApp.textCol2),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "Overview",
                                style: _textStyleApp.subHead1
                                    .copyWith(color: _colorApp.textCol2),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "${snapshot.data!.overview}",
                                style: _textStyleApp.textL
                                    .copyWith(color: _colorApp.textCol2),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(12),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _colorApp.tertiaryCol,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Status",
                                          style: _textStyleApp.textS.copyWith(
                                              color: _colorApp.textCol3),
                                        ),
                                        Text(
                                          "${snapshot.data!.status}",
                                          style: _textStyleApp.textXL.copyWith(
                                              color: _colorApp.textCol3,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    VerticalDivider(
                                      width: 37,
                                      thickness: 0.5,
                                      color: _colorApp.primaryCol,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Release date",
                                          style: _textStyleApp.textS.copyWith(
                                              color: _colorApp.textCol3),
                                        ),
                                        Text(
                                          "${snapshot.data!.releaseDate}",
                                          style: _textStyleApp.textXL.copyWith(
                                              color: _colorApp.textCol3,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    VerticalDivider(
                                      width: 37,
                                      thickness: 0.5,
                                      color: _colorApp.primaryCol,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Language",
                                          style: _textStyleApp.textS.copyWith(
                                              color: _colorApp.textCol3),
                                        ),
                                        Text(
                                          "${snapshot.data!.originalLanguage}",
                                          style: _textStyleApp.textXL.copyWith(
                                              color: _colorApp.textCol3,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "Cast",
                                style: _textStyleApp.subHead1
                                    .copyWith(color: _colorApp.textCol2),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            FutureBuilder(
                              future: _httpService
                                  .getMovieCredits(widget.movieID.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox(
                                    height: 180,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return Shimmer.fromColors(
                                          baseColor: _colorApp.baseColShimmer,
                                          highlightColor:
                                              _colorApp.highlightColShimmer,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            width: 100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Container(
                                                  width: 80,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Text(
                                      "${snapshot.error}",
                                      style: _textStyleApp.textXL
                                          .copyWith(color: _colorApp.textCol2),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 185,
                                    child: ListView.builder(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.cast?.length,
                                      itemBuilder: (context, index) {
                                        if (snapshot.data!.cast?[index]
                                                .profilePath ==
                                            null) {
                                          return Container(
                                            margin: EdgeInsets.only(left: 10),
                                            width: 100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        _colorApp.secondaryCol,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .error_outline_rounded,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        "Image Not Found:(",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: _textStyleApp
                                                            .textS
                                                            .copyWith(
                                                                fontSize: 8,
                                                                color: Colors
                                                                    .white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  "${snapshot.data!.cast?[index].name}",
                                                  style: _textStyleApp.textL
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: _colorApp
                                                              .textCol2),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  "${snapshot.data!.cast?[index].character}",
                                                  style: _textStyleApp.textS
                                                      .copyWith(
                                                    color: _colorApp.textCol2,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            margin: EdgeInsets.only(left: 10),
                                            width: 100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      "${Constants.imagePath}${snapshot.data!.cast?[index].profilePath}",
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image: DecorationImage(
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .high,
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider)),
                                                    );
                                                  },
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Icon(Icons
                                                          .error_outline_rounded),
                                                  placeholder: (context, url) =>
                                                      Shimmer.fromColors(
                                                    baseColor: _colorApp
                                                        .baseColShimmer,
                                                    highlightColor: _colorApp
                                                        .highlightColShimmer,
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  "${snapshot.data!.cast?[index].name}",
                                                  style: _textStyleApp.textL
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: _colorApp.textCol2,
                                                  ),
                                                ),
                                                Text(
                                                  "${snapshot.data!.cast?[index].character}",
                                                  style: _textStyleApp.textS
                                                      .copyWith(
                                                    color: _colorApp.textCol2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   itemCount: 1,
                            //   itemBuilder: (context, index) {
                            //     var data = _list[index];
                            //     return TextButton(
                            //         onPressed: () {
                            //           launchUrl(Uri.parse(
                            //               "https://www.youtube.com/watch?v=${data.key}"));
                            //         },
                            //         child: Text(
                            //           data.key.toString(),
                            //           style: _textStyleApp.subHead3
                            //               .copyWith(color: _colorApp.textCol2),
                            //         ));
                            //   },
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "Trailer",
                                style: _textStyleApp.subHead3
                                    .copyWith(color: _colorApp.textCol2),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            InkWell(
                              onTap: () {
                                launchUrl(Uri.parse(
                                    "https://www.youtube.com/watch?v=${_list[1].key}"));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                width: double.infinity,
                                height: 187,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        filterQuality: FilterQuality.high,
                                        image: NetworkImage(
                                            "${Constants.imagePath}${snapshot.data!.backdropPath}"))),
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            // FutureBuilder(
                            //   future: _httpService
                            //       .getMovieTrailer(widget.movieID.toString()),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       return CircularProgressIndicator();
                            //     } else if (snapshot.hasError) {
                            //       return Text(
                            //         "${snapshot.error}",
                            //         style: _textStyleApp.subHead3
                            //             .copyWith(color: _colorApp.textCol2),
                            //       );
                            //     } else {
                            //       return Container(
                            //         margin:
                            //             EdgeInsets.symmetric(horizontal: 12),
                            //         width: double.infinity,
                            //         height: 187,
                            //         decoration: BoxDecoration(
                            //           color: Colors.white,
                            //           borderRadius: BorderRadius.circular(15),
                            //         ),
                            //         child: TextButton(
                            //             onPressed: () {
                            //               // Link();
                            //               launchUrl(Uri.parse(
                            //                   "https://www.youtube.com/watch?v=${snapshot.data!.results[1].key}"));
                            //             },
                            //             child: Text("Example Link Treailer")),
                            //       );
                            //     }
                            //   },
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
