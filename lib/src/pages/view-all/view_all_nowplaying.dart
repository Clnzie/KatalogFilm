import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieNowPlaying.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:flutter/material.dart';

import '../../Utils/constant.dart';
import '../../widgets/card_movie.dart';
import '../core/homepage.dart';
import '../core/movie_detail.dart';

class ViewAllNowplaying extends StatefulWidget {
  const ViewAllNowplaying({super.key});

  @override
  State<ViewAllNowplaying> createState() => _ViewAllNowplayingState();
}

class _ViewAllNowplayingState extends State<ViewAllNowplaying> {
  final ColorApp _colorApp = ColorApp();
  final TextStyleApp _textStyleApp = TextStyleApp();
  final HttpService httpService = HttpService();
  final List<MovieNowPlayingList> _movieList = [];
  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _paginationMovie();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _paginationMovie();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  _paginationMovie() async {
    setState(() {
      isLoading = true;
    });
    List<MovieNowPlayingList> newListApi =
        await httpService.getMovieNowPlayingList(page: currentPage);
    setState(() {
      isLoading = false;
      _movieList.addAll(newListApi);
      currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: _colorApp.textCol2,
                          size: 18,
                        )),
                  ),
                  Text(
                    "Now Playing",
                    style: _textStyleApp.subHead1
                        .copyWith(color: _colorApp.textCol2),
                  )
                ],
              ),
            )),
        backgroundColor: Color(0xff171717),
        body: ListView(
          controller: scrollController,
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8),
              shrinkWrap: true,
              itemCount: isLoading ? _movieList.length + 1 : _movieList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 210,
                mainAxisSpacing: 6,
                // crossAxisSpacing: 0,
              ),
              itemBuilder: (context, index) {
                if (index < _movieList.length) {
                  MovieNowPlayingList data = _movieList[index];
                  return CardMovie(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetail(
                              movieID: data.id ?? 0,
                            ),
                          ));
                    },
                    imgPoster: "${Constants.imagePath}${data.posterPath}",
                    title: "${data.title}",
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
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
    );
  }
}


// FutureBuilder<MovieNowPlaying>(
//               future: movieNowPlaying,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return GridView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     padding: EdgeInsets.symmetric(horizontal: 8),
//                     shrinkWrap: true,
//                     itemCount: 20,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       mainAxisExtent: 210,
//                       mainAxisSpacing: 6,
//                       // crossAxisSpacing: 0,
//                     ),
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                         child: ShimmerCard(),
//                       );
//                     },
//                   );
//                 } else if (snapshot.hasError) {
//                   return Text("${snapshot.error}");
//                 } else {
//                   return GridView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     padding: EdgeInsets.symmetric(horizontal: 8),
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.results.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       mainAxisExtent: 210,
//                       mainAxisSpacing: 6,
//                       // crossAxisSpacing: 0,
//                     ),
//                     itemBuilder: (context, index) {
//                       return CardMovie(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MovieDetail(
//                                     movieID: snapshot.data!.results[index].id,
//                                   ),
//                                 ));
//                           },
//                           imgPoster:
//                               "${Constants.imagePath}${snapshot.data!.results[index].posterPath}",
//                           title: "${snapshot.data!.results[index].title}");
//                     },
//                   );
//                 }
//               },
//             )