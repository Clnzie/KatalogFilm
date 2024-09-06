import 'dart:async';
import 'dart:convert';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieCreditsModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieDetailModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieNowPlaying.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieSearchModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTopRateModelApi.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String apiKey = "b0b1b7542963befc2f848ce363e5c4ab";

  Future<MoviePopular> getMoviePopular() async {
    final String uri =
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      return MoviePopular.fromJson(jsonDecode(response.body));
    }

    var responseReturn = jsonDecode(response.body);

    return responseReturn;
  }

  Future<List<MoviePopularList>> getMoviePopularList(int page) async {
    final String uri =
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&page=$page";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responDecode = jsonDecode(response.body);
      final List<dynamic> responJson = responDecode["results"];
      return responJson.map((e) => MoviePopularList.fromJson(e)).toList();
    } else {
      print("asad");
      throw Exception("Error get List API");
    }
  }

  Future<MovieTopRated> getMovieTopRate() async {
    final String uri =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      return MovieTopRated.fromJson(jsonDecode(response.body));
    }

    var responseReturn = jsonDecode(response.body);

    return responseReturn;
  }

  Future<List<MovieTopRatedList>> getMovieTopRatedList(int page) async {
    final String uri =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&page=$page";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responDecode = jsonDecode(response.body);
      final List<dynamic> responJson = responDecode["results"];
      return responJson.map((e) => MovieTopRatedList.fromJson(e)).toList();
    } else {
      print("asad");
      throw Exception("Error get List API");
    }
  }

  Future<Map<String, dynamic>> getMovieNowPlaying({
    required int page,
    required String minDate,
    required String maxDate,
  }) async {
    try {
      final String uri =
          "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&page=$page&release_date.gte=$minDate&release_date.lte=$maxDate";

      http.Response response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonRespon = jsonDecode(response.body);
        return jsonRespon;
      } else {
        throw Exception("error ro get api Now Playing Movie");
      }

      // var responeReturn = jsonDecode(response.body);

      // return responeReturn;
    } catch (e) {
      throw Exception("error API");
    }
  }

  Future<List<MovieNowPlayingList>> getMovieNowPlayingList({
    required int page,
  }) async {
    final String uri =
        "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&page=$page";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responDecode = jsonDecode(response.body);
      final List<dynamic> responJson = responDecode["results"];
      return responJson.map((e) => MovieNowPlayingList.fromJson(e)).toList();
    } else {
      print("asad");
      throw Exception("Error get List API");
    }
  }

  Future<MovieDetailApi> getDetailMovie(String id) async {
    final String uri = "https://api.themoviedb.org/3/movie/$id?api_key=$apiKey";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      print("Succes Get API");

      return MovieDetailApi.fromJson(jsonDecode(response.body));
    }
    var responseReturn = jsonDecode(response.body);

    return responseReturn;
  }

  Future<MovieCredits> getMovieCredits(String movieID) async {
    final String uri =
        "https://api.themoviedb.org/3/movie/$movieID/credits?api_key=$apiKey";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      return MovieCredits.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }

    var responRetrun = jsonDecode(response.body);

    return responRetrun;
  }

  Future<List<MovieSearch>> fetchSearch(String query, int page) async {
    final String uri =
        "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query&page=$page";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseDecode = jsonDecode(response.body);
      final List<dynamic> responseResult = responseDecode['results'];
      final assd = responseResult.map((e) => MovieSearch.fromJson(e)).toList();
      return assd;
    } else {
      // throw MessageProperty("error", "Error to get data");
      throw Exception("error to get data!!");
    }
  }
}
