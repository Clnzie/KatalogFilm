import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  final ColorApp _colorApp = ColorApp();
  final TextStyleApp _textStyleApp = TextStyleApp();
  final HttpService _httpService = HttpService();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 42),
            child: Container(
              color: Colors.transparent,
            )),
        extendBodyBehindAppBar: true,
        extendBody: false,
        body: Stack(
          children: [
            ListView(
              children: [
                FutureBuilder(
                    future:
                        _httpService.getDetailMovie(widget.movieID.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return CachedNetworkImage(
                          imageUrl:
                              "${Constants.imagePath}${snapshot.data!.backdropPath}",
                          imageBuilder: (context, imageProvider) {
                            return Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.sizeOf(context).height / 3.52,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.fitHeight,
                                          image: imageProvider)),
                                ),
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 3.52,
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
                        );
                      }
                    })
              ],
            ),
            //Appbar
            // Container(
            //   width: double.infinity,
            //   height: 42,
            //   child: Row(
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         icon: Icon(Icons.arrow_back_ios_rounded),
            //         iconSize: 18,
            //         color: _colorApp.textCol2,
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
