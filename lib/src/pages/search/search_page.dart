import 'package:Itil.Co/src/SetUp/MovieAPI.dart';
import 'package:Itil.Co/src/Utils/color.dart';
import 'package:Itil.Co/src/Utils/constant.dart';
import 'package:Itil.Co/src/Utils/typography.dart';
import 'package:Itil.Co/src/pages/core/movie_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../SetUp/modelsAPI/MovieSearchModelApi.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ColorApp _colorApp = ColorApp();
  final TextStyleApp _textStyleApp = TextStyleApp();
  final HttpService _httpService = HttpService();
  final TextEditingController textEditingController = TextEditingController();
  late Future<List<MovieSearch>> _searchResults;
  final ScrollController scrollController = ScrollController();
  List<MovieSearch> _listMovie = [];
  int currentPage = 1;
  bool isLoading = false;
  String _querySearch = '';

  // void _searchMovies(String query) async {
  //   setState(() {
  //     isLoading = true;
  //     _listMovie.clear();
  //   });

  //   List<MovieSearch> newList =
  //       await _httpService.fetchSearch(query, currentPage);
  //   setState(() {
  //     _listMovie = newList;
  //     isLoading = false;
  //   });
  // }

  // _paginationMovie() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   List<MovieSearch> newList =
  //       await _httpService.fetchSearch(textEditingController.text, currentPage);
  //   setState(() {
  //     isLoading = false;
  //     _listMovie.addAll(newList);
  //     currentPage++;
  //   });
  // }

  Future<void> _fetchMoreItem() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    List<MovieSearch> newItems =
        await _httpService.fetchSearch(_querySearch, currentPage);

    setState(() {
      isLoading = false;
      _listMovie.addAll(newItems);
      currentPage++;
    });
  }

  void _searchMovie(String query) {
    setState(() {
      _querySearch = query;
      _listMovie.clear();
      currentPage = 1;
      _fetchMoreItem();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMoreItem();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _fetchMoreItem();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff171717),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(90),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          size: 24,
                          color: _colorApp.quartiaryCol,
                        )),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 43,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextFormField(
                        // autofocus: true,
                        controller: textEditingController,
                        cursorColor: _colorApp.quartiaryCol,

                        showCursor: true,
                        style: _textStyleApp.textXL.copyWith(
                          color: _colorApp.textCol2,
                        ),

                        onFieldSubmitted: (value) => _searchMovie(value),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Find Your Movie",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          hintStyle: _textStyleApp.textXL.copyWith(
                              color: Color.fromARGB(155, 255, 255, 255)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                textEditingController.clear();
                              },
                              icon: Icon(Icons.close_rounded)),
                          suffixIconColor: _colorApp.quartiaryCol,
                          prefixIcon: IconButton(
                              onPressed: () {
                                _searchMovie(textEditingController.text);
                              },
                              icon: Icon(Icons.search_rounded)),
                          prefixIconColor: _colorApp.quartiaryCol,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        body: _listMovie.isEmpty
            ? Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "(┬┬﹏┬┬)",
                              style: _textStyleApp.headLines1
                                  .copyWith(color: _colorApp.textCol2),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "No One Movie We Found",
                              style: _textStyleApp.textXL
                                  .copyWith(color: _colorApp.textCol2),
                            )
                          ],
                        ),
                      ),
              )
            : ListView.builder(
                controller: scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shrinkWrap: true,
                itemCount: _listMovie.length + 1,
                itemBuilder: (context, index) {
                  // Return Jika terdapat PosterPath yng bernilai null
                  if (index == _listMovie.length) {
                    return isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox.shrink();
                  } else {
                    if (_listMovie[index].posterPath == null) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetail(
                                        movieID: _listMovie[index].id ?? 0,
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          height: 136,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 57, 57, 57),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  width: 85,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_rounded,
                                        size: 24,
                                        color: _colorApp.quartiaryCol,
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "No Image Available",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: _textStyleApp.textS.copyWith(
                                          color: _colorApp.textCol2,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _listMovie[index].title ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: _textStyleApp.subHead3
                                          .copyWith(color: _colorApp.textCol2),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          size: 24,
                                          color: _colorApp.tertiaryCol,
                                        ),
                                        Text(
                                          _listMovie[index]
                                                  .voteAverage
                                                  .toString()
                                                  .substring(0, 3) +
                                              " " +
                                              "TMBD",
                                          style: _textStyleApp.textL.copyWith(
                                              color: _colorApp.textQuartiary),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _listMovie[index].overview ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: _textStyleApp.textL
                                          .copyWith(color: _colorApp.textCol2),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      //Return Jika data tidak terdapat nilai null
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetail(
                                        movieID: _listMovie[index].id ?? 0,
                                      )));
                        },
                        child: CustomTile(
                            img:
                                "${Constants.imagePath}${_listMovie[index].posterPath}",
                            title: _listMovie[index].title ?? "",
                            rating: _listMovie[index]
                                .voteAverage
                                .toString()
                                .substring(0, 3),
                            overview: _listMovie[index].overview ?? ""),
                      );
                    }
                  }
                },
              ),
      ),
    );
  }

  Container CustomTile(
      {required String img,
      required String title,
      required String rating,
      required String overview}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      height: 136,
      decoration: BoxDecoration(
          color: Color(0xFF393939), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CachedNetworkImage(
              imageUrl: img,
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: 85,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          image: imageProvider)),
                );
              },
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: _colorApp.baseColShimmer,
                highlightColor: _colorApp.highlightColShimmer,
                child: Container(
                  width: 85,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyleApp.subHead3
                      .copyWith(color: _colorApp.textCol2),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 24,
                      color: _colorApp.tertiaryCol,
                    ),
                    Text(
                      rating + " " + "TMBD",
                      style: _textStyleApp.textL
                          .copyWith(color: _colorApp.textQuartiary),
                    ),
                  ],
                ),
                Text(
                  overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      _textStyleApp.textL.copyWith(color: _colorApp.textCol2),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget ShimmerTile() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      height: 136,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff2E2D2D),
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: _colorApp.baseColShimmer,
            highlightColor: _colorApp.highlightColShimmer,
            child: Container(
              width: 85,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.red),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            children: [
              Container(
                width: 223,
                height: 24,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(50)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
