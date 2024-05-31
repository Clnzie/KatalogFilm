import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetail extends StatefulWidget {
  final int movieID;
  final String title,
      originalTitle,
      backdrop_path,
      overview,
      poster_path,
      release_date,
      popularity,
      vote_average,
      vote_count,
      language;
  final List<int>? genre;

  const MovieDetail(
      {super.key,
      required this.movieID,
      required this.title,
      required this.originalTitle,
      required this.backdrop_path,
      required this.overview,
      required this.poster_path,
      required this.release_date,
      required this.vote_average,
      required this.vote_count,
      required this.popularity,
      required this.language,
      required this.genre});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  // late final YoutubePlayerController _controller = YoutubePlayerController(
  //   initialVideoId: "QslJYDX3o8s",
  //   flags: YoutubePlayerFlags(
  //     autoPlay: false,
  //   ),
  // );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ListView(
              children: [
                CachedNetworkImage(
                  imageUrl: "${Constants.imagePath}${widget.backdrop_path}",
                  imageBuilder: (context, imageProvider) {
                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height / 3.52,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.fitHeight,
                                  image: imageProvider)),
                        ),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 3.52,
                          color: Color.fromARGB(80, 0, 0, 0),
                        ),
                      ],
                    );
                  },
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Color(0xff3a3a3a),
                    highlightColor: Color.fromARGB(255, 92, 91, 91),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3.52,
                      color: Color(0xff3a3a3a),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 24),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryCol,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 9, bottom: 18),
                          width: 90,
                          height: 16,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "${Constants.imagePath}${widget.poster_path}",
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: 115,
                                  height: 171,
                                  decoration: BoxDecoration(
                                      // color: textQuartiary,
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.fill,
                                          image: imageProvider)),
                                );
                              },
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Color(0xff3a3a3a),
                                highlightColor: Color.fromARGB(255, 92, 91, 91),
                                child: Container(
                                  width: 115,
                                  height: 171,
                                  decoration: BoxDecoration(
                                      color: Color(0xff3a3a3a),
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.title}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: subHead1.copyWith(
                                        color: textCol2,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Center(
                                          child: Icon(
                                            Icons.star_rounded,
                                            color: textCol1,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        widget.vote_average.substring(0, 3),
                                        style: subHead3.copyWith(
                                            color: textCol2,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "${widget.release_date}",
                                    style: textL.copyWith(
                                        color:
                                            Color.fromARGB(255, 165, 164, 164)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      SizedBox(
                        height: 32,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 9),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: widget.genre?.length,
                          itemBuilder: (context, index) {
                            int genreID = widget.genre![index];
                            String genreName = getGenreName(genreID);
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: textCol2, width: 1)),
                              child: Center(
                                child: Text(
                                  genreName,
                                  style: textL.copyWith(
                                      color: textCol2,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Overview",
                              style: subHead1.copyWith(color: textCol2),
                            ),
                            Text(
                              "${widget.overview}",
                              style: textL.copyWith(color: textCol2),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 14),
                        child: Column(
                          children: [
                            Text(
                              "Tralier",
                              style: subHead1.copyWith(color: textCol2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      )
                    ],
                  ),
                )
              ],
            ),
            //Appbar
            Container(
              width: double.infinity,
              height: 42,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    iconSize: 18,
                    color: textCol2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
}
