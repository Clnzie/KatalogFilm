import 'dart:convert';
import 'dart:ui';

import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTrailerModelApi.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
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
  late FToast fToast;

  // getData() async {
  //   List<MovieTrailerList?> listMovie =
  //       await _httpService.getMovieTrailerList(widget.movieID.toString());
  //   _list = listMovie;
  // print(listMovie);
  // }

  Future<void> getMovieTrailerList() async {
    final String url =
        "https://api.themoviedb.org/3/movie/${widget.movieID}/videos?api_key=b0b1b7542963befc2f848ce363e5c4ab";

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseDecode = jsonDecode(response.body);
      final List<dynamic> responseData = responseDecode["results"];
      // print("asdasda ${responseData} asdasdas");

      _list = responseData.map((e) => MovieTrailerList.fromJson(e)).toList();
    } else {
      throw Exception("Error to load Data");
    }
  }

  @override
  void initState() {
    getMovieTrailerList();
    fToast = FToast();
    fToast.init(context);
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
                      // Poster Movie
                      (snapshot.data!.posterPath != null)
                          ? CachedNetworkImage(
                              imageUrl:
                                  "${Constants.imagePath}${snapshot.data!.posterPath}",
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 1.40,
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
                                          MediaQuery.of(context).size.height /
                                              1.40,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                _colorApp.primaryCol
                                                    .withOpacity(0),
                                                _colorApp.primaryCol
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              stops: [0.5, 0.95])),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, top: 15),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 9.6, sigmaY: 9.6),
                                                child: Container(
                                                  width: 45,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromARGB(
                                                          109, 23, 23, 23)),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_back_rounded,
                                                      size: 26,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) => Icon(
                                    Icons.image,
                                    size: 24,
                                    color: _colorApp.secondaryCol,
                                  ))
                          : Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 1.40,
                              decoration: BoxDecoration(
                                  color: _colorApp.secondaryCol,
                                  gradient: LinearGradient(
                                      colors: [
                                        _colorApp.secondaryCol,
                                        _colorApp.primaryCol
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.5, 0.95])),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, top: 15),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 9.6, sigmaY: 9.6),
                                            child: Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromARGB(
                                                      109, 23, 23, 23)),
                                              child: Center(
                                                child: Icon(
                                                  Icons.arrow_back_rounded,
                                                  size: 26,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_rounded,
                                          size: 45,
                                          color: _colorApp.quartiaryCol,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          "No Image Available",
                                          style: _textStyleApp.subHead1
                                              .copyWith(
                                                  color: _colorApp.textCol2),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                      // Detail Film
                      Container(
                        width: double.infinity,
                        color: _colorApp.primaryCol,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Vote Avarage & popularity Movie
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

                            // Judul Movie
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

                            // Genre Movie
                            SizedBox(
                              height: 30,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.genres!.length,
                                itemBuilder: (context, index) {
                                  final genres = snapshot.data!.genres![index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
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

                            // Overview Movie
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

                            (snapshot.data!.overview!.isNotEmpty)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      "${snapshot.data!.overview}",
                                      textAlign: TextAlign.justify,
                                      style: _textStyleApp.textL
                                          .copyWith(color: _colorApp.textCol2),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline_rounded,
                                          size: 24,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "We couldn't find an overview of this movie",
                                          style: _textStyleApp.textL.copyWith(
                                              color: _colorApp.textCol2),
                                        ),
                                      ],
                                    ),
                                  ),

                            // Informasi Movie
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
                                        (snapshot.data!.releaseDate!.isNotEmpty)
                                            ? Text(
                                                "${snapshot.data!.releaseDate}",
                                                style: _textStyleApp.textXL
                                                    .copyWith(
                                                        color:
                                                            _colorApp.textCol3,
                                                        fontWeight:
                                                            FontWeight.w500))
                                            : Text(
                                                '-',
                                                style: _textStyleApp.textXL
                                                    .copyWith(
                                                        color:
                                                            _colorApp.textCol3,
                                                        fontWeight:
                                                            FontWeight.w500),
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

                            // Pemeran / Voice Actor & Actress
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
                                  // Return jika Cast pada movie IsNotEmpty
                                  if (snapshot.data!.cast!.isNotEmpty) {
                                    return SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.cast?.length,
                                        itemBuilder: (context, index) {
                                          if (snapshot.data!.cast?[index]
                                                  .profilePath ==
                                              null) {
                                            // Return jika terdapat profilePath yang bernilai null
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              width: 100,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: _colorApp
                                                          .secondaryCol,
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
                                                          Icons.image_rounded,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "No Image Available",
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          style: _textStyleApp
                                                              .textS
                                                              .copyWith(
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
                                            // Return jika semua data tidak terdapat nilai null
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              width: 100,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                        "${Constants.imagePath}${snapshot.data!.cast?[index].profilePath}",
                                                    imageBuilder: (context,
                                                        imageProvider) {
                                                      return Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            image: DecorationImage(
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                                fit: BoxFit
                                                                    .cover,
                                                                image:
                                                                    imageProvider)),
                                                      );
                                                    },
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Icon(Icons
                                                            .error_outline_rounded),
                                                    placeholder:
                                                        (context, url) =>
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
                                                                    .circular(
                                                                        15),
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
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                  } else {
                                    // Return jika cast pada movie IsEmpty
                                    return Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline_rounded,
                                          size: 24,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "We could not find the cast in this film",
                                          style: _textStyleApp.textL.copyWith(
                                              color: _colorApp.textCol2),
                                        )
                                      ],
                                    );
                                  }
                                }
                              },
                            ),

                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "Trailer",
                                style: _textStyleApp.subHead1
                                    .copyWith(color: _colorApp.textCol2),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),

                            // Trailer Movie (Langsung diarahkan ke yt)
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    (snapshot.data!.backdropPath != null)
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                "${Constants.imagePath}${snapshot.data!.backdropPath}",
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image(
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fit: BoxFit.cover,
                                                    image: imageProvider,
                                                    width: double.infinity,
                                                    height: 187,
                                                  ),
                                                ),
                                              );
                                            },
                                            placeholder: (context, url) =>
                                                Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Shimmer.fromColors(
                                                baseColor:
                                                    _colorApp.baseColShimmer,
                                                highlightColor: _colorApp
                                                    .highlightColShimmer,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 187,
                                                  decoration: BoxDecoration(
                                                      color: _colorApp
                                                          .secondaryCol,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                ),
                                              ),
                                            ),
                                            errorListener: (value) => Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              width: double.infinity,
                                              height: 187,
                                              decoration: BoxDecoration(
                                                  color: _colorApp.secondaryCol,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image_rounded,
                                                    size: 35,
                                                    color:
                                                        _colorApp.quartiaryCol,
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    "No Image Available",
                                                    style: _textStyleApp
                                                        .subHead3
                                                        .copyWith(
                                                            color: _colorApp
                                                                .textCol2),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            width: double.infinity,
                                            height: 187,
                                            decoration: BoxDecoration(
                                                color: _colorApp.secondaryCol,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_rounded,
                                                  size: 35,
                                                  color: _colorApp.quartiaryCol,
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  "No Image Available",
                                                  style: _textStyleApp.subHead3
                                                      .copyWith(
                                                          color: _colorApp
                                                              .textCol2),
                                                )
                                              ],
                                            ),
                                          ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          if (_list.isEmpty) {
                                            print("Ganok Data ne BLOK");
                                            print(_list);
                                            _toastTrailer();
                                          } else {
                                            // print(_list);
                                            launchUrl(Uri.parse(
                                                "https://www.youtube.com/watch?v=${_list[0].key}"));
                                          }
                                        },
                                        icon: Icon(Icons.play_arrow_rounded),
                                        label: Text(
                                          "Play Trailer",
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    // _list.isEmpty
                                                    //     ? _colorApp.secondaryCol
                                                    //     :
                                                    _colorApp.tertiaryCol),
                                            minimumSize: WidgetStatePropertyAll(
                                                Size(double.infinity, 40)),
                                            shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                                    // _list.isEmpty
                                                    //     ? Color(0xff999999)
                                                    //     :
                                                    _colorApp.textCol2),
                                            textStyle: WidgetStatePropertyAll(
                                                _textStyleApp.textXL.copyWith(
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            iconSize:
                                                WidgetStatePropertyAll(24),
                                            iconColor: WidgetStatePropertyAll(
                                                // _list.isEmpty
                                                //   ? Color(0xff999999)
                                                //   :
                                                _colorApp.textCol2),
                                            overlayColor:
                                                WidgetStatePropertyAll(
                                                    // _list.isEmpty ? Colors.transparent :
                                                    _colorApp.quartiaryCol
                                                        .withOpacity(0.2))),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                            SizedBox(
                              height: 24,
                            ),
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

  _toastTrailer() {
    Widget toast = Container(
      padding: EdgeInsets.all(12),
      height: 42,
      width: 210,
      decoration: BoxDecoration(
          color: _colorApp.quartiaryCol,
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text(
          "Movie Trailer Not Found :(",
          style: _textStyleApp.textL.copyWith(color: _colorApp.textCol3),
        ),
      ),
    );
    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4));
  }
}

//  ButtonStyle(
//                                                 backgroundColor:
//                                                     WidgetStatePropertyAll(
//                                                         _colorApp.secondaryCol),
//                                                 minimumSize:
//                                                     WidgetStatePropertyAll(Size(
//                                                         double.infinity, 40)),
//                                                 shape: WidgetStatePropertyAll(
//                                                   RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15),
//                                                   ),
//                                                 ),
//                                                 foregroundColor:
//                                                     WidgetStatePropertyAll(
//                                                         Color(0xff999999)),
//                                                 textStyle:
//                                                     WidgetStatePropertyAll(
//                                                         _textStyleApp.textXL
//                                                             .copyWith(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500)),
//                                                 iconSize:
//                                                     WidgetStatePropertyAll(24),
//                                                 iconColor:
//                                                     WidgetStatePropertyAll(
//                                                         Color(0xff999999)),
//                                               )
