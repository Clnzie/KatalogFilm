import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:Itil.Co/src/pages/core/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidable/hidable.dart';
import 'package:readmore/readmore.dart';

class MovieDetail extends StatefulWidget {
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
  // final List<int> genre

  const MovieDetail(
      {super.key,
      required this.title,
      required this.originalTitle,
      required this.backdrop_path,
      required this.overview,
      required this.poster_path,
      required this.release_date,
      required this.vote_average,
      required this.vote_count,
      required this.popularity,
      required this.language});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  // ScrollController _controller = ScrollController();

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
                Stack(
                  children: [
                    Image(
                        image: NetworkImage(
                            "${Constants.imagePath}${widget.backdrop_path}")),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3.52,
                      color: Color.fromARGB(80, 0, 0, 0),
                    )
                  ],
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
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 9, bottom: 18),
                        width: 90,
                        height: 16,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 115,
                              height: 171,
                              decoration: BoxDecoration(
                                  color: textQuartiary,
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      filterQuality: FilterQuality.high,
                                      image: NetworkImage(
                                          "${Constants.imagePath}${widget.poster_path}"))),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.title}",
                                  style: subHead2.copyWith(
                                      color: textCol2,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rate_rounded,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                    Text(
                                      widget.vote_average.substring(0, 3),
                                      style: textXL.copyWith(
                                          color: textCol2,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
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
}

// ListView asdasd(AsyncSnapshot<Movie> snapshot) {
//   return ListView.builder(
//     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//     controller: _controller,
//     physics: BouncingScrollPhysics(),
//     itemCount: snapshot.data!.results.length,
//     shrinkWrap: true,
//     itemBuilder: (context, index) {
//       return Container(
//         padding: EdgeInsets.all(10),
//         margin: EdgeInsets.only(bottom: 8),
//         height: 170,
//         decoration: BoxDecoration(
//             color: secondaryCol, borderRadius: BorderRadius.circular(12)),
//         child: Row(
//           children: [
//             //Poster Film
//             Container(
//               width: 110,
//               decoration: BoxDecoration(
//                   color: Color.fromARGB(142, 198, 198, 198),
//                   borderRadius: BorderRadius.circular(10),
//                   image: DecorationImage(
//                       filterQuality: FilterQuality.high,
//                       fit: BoxFit.fill,
//                       image: NetworkImage(
//                           "${Constants.imagePath}${snapshot.data!.results[index].posterPath}"))),
//             ),
//             SizedBox(
//               width: 8,
//             ),
//             Expanded(
//               flex: 10,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   //Judul Film
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${snapshot.data!.results[index].title}",
//                         overflow: TextOverflow.ellipsis,
//                         style: subHead1.copyWith(color: textCol2),
//                       ),
//                       //Release Date FIlm
//                       Text(
//                         snapshot.data!.results[index].releaseDate.toString(),
//                         overflow: TextOverflow.ellipsis,
//                         style: textXL.copyWith(color: textQuartiary),
//                       ),
//                       //Rating Film
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.star_rounded,
//                             color: Colors.yellow,
//                             size: 24,
//                           ),
//                           Text(
//                             snapshot.data!.results[index].voteAverage
//                                 .toString()
//                                 .substring(0, 3),
//                             overflow: TextOverflow.ellipsis,
//                             style: subHead3.copyWith(color: textCol2),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   //Button => next page
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(context, MaterialPageRoute(
//                         builder: (context) {
//                           return MovieDetail(
//                             backdrop_path:
//                                 snapshot.data!.results[index].backdropPath,
//                             overview: snapshot.data!.results[index].overview,
//                             poster_path:
//                                 snapshot.data!.results[index].posterPath,
//                             release_date:
//                                 snapshot.data!.results[index].releaseDate,
//                             title: snapshot.data!.results[index].title,
//                             vote_average: snapshot
//                                 .data!.results[index].voteAverage
//                                 .toString(),
//                             popularity: snapshot
//                                 .data!.results[index].popularity
//                                 .toString(),
//                             language: snapshot
//                                 .data!.results[index].originalLanguage,
//                           );
//                         },
//                       ));
//                     },
//                     child: Text(
//                       "More",
//                       overflow: TextOverflow.ellipsis,
//                       style: textXL.copyWith(
//                           color: primaryCol, fontWeight: FontWeight.bold),
//                     ),
//                     style: elevatedButtonStyle.copyWith(
//                         shape: MaterialStateProperty.all(
//                             RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(50))),
//                         minimumSize:
//                             MaterialStateProperty.all(Size(110, 42))),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       );
//     },
//   );
// }
