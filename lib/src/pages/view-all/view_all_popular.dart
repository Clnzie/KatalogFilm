import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieModelApi.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:Itil.Co/src/pages/core/homepage.dart';
import 'package:Itil.Co/src/pages/core/movie_detail.dart';
import 'package:Itil.Co/src/widgets/card_movie.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ViewAllPopular extends StatefulWidget {
  const ViewAllPopular({super.key});

  @override
  State<ViewAllPopular> createState() => _ViewAllPopularState();
}

class _ViewAllPopularState extends State<ViewAllPopular> {
  final HttpService httpService = HttpService();
  late Future<Movie> movie;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movie = httpService.getMovie();
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
                          color: textCol2,
                          size: 18,
                        )),
                  ),
                  Text(
                    "Popular",
                    style: subHead1.copyWith(color: textCol2),
                  )
                ],
              ),
            )),
        backgroundColor: Color(0xff171717),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            FutureBuilder<Movie>(
              future: movie,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.results.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 171,
                      mainAxisSpacing: 6,
                      // crossAxisSpacing: 0,
                    ),
                    itemBuilder: (context, index) {
                      return CardMovie(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetail(
                                      movieID: snapshot.data!.results[index].id,
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
                          title: "${snapshot.data!.results[index].title}");
                    },
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
