// To parse this JSON data, do
//
//     final movieSearch = movieSearchFromJson(jsonString);

import 'dart:convert';

MovieSearch movieSearchFromJson(String str) =>
    MovieSearch.fromJson(json.decode(str));

String movieSearchToJson(MovieSearch data) => json.encode(data.toJson());

class MovieSearch {
  List<int>? genreIds;
  int? id;

  String? originalTitle;
  String? overview;

  String? posterPath;

  String? title;

  double? voteAverage;

  MovieSearch({
    this.genreIds,
    this.id,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.title,
    this.voteAverage,
  });

  factory MovieSearch.fromJson(Map<String, dynamic> json) => MovieSearch(
        genreIds: json["genre_ids"] == null
            ? []
            : List<int>.from(json["genre_ids"]!.map((x) => x)),
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        title: json["title"],
        voteAverage: json["vote_average"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "genre_ids":
            genreIds == null ? [] : List<dynamic>.from(genreIds!.map((x) => x)),
        "id": id,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "title": title,
        "vote_average": voteAverage,
      };
}
