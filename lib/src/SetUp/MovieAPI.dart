import 'dart:convert';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieCreditsModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieDetailModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieNowPlaying.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTrailerModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTopRateModelApi.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String apiKey = "b0b1b7542963befc2f848ce363e5c4ab";

  Future<Movie> getMovie() async {
    final String uri =
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body));
    }

    var responseReturn = jsonDecode(response.body);

    return responseReturn;
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

  Future<MovieDetailApi> getDetailMovie(String id) async {
    final String uri = "https://api.themoviedb.org/3/movie/$id?api_key=$apiKey";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      print("Succes Get API");
      // final jsonResponse = jsonDecode(response.body) as List;
      // return jsonResponse.map((e) => MovieDetailApi?.fromJson(e)).toList();
      return MovieDetailApi.fromJson(jsonDecode(response.body));
    }
    var responseReturn = jsonDecode(response.body);

    return responseReturn;
  }

  Future<MovieNowPlaying> getMovieNowPlaying() async {
    try {
      final String uri =
          "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";

      http.Response response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return MovieNowPlaying.fromJson(jsonDecode(response.body));
      }

      var responeReturn = jsonDecode(response.body);

      return responeReturn;
    } catch (e) {
      throw Exception("error API");
    }
  }

  Future<List<MovieTrailerList?>> getMovieTrailerList(String movieID) async {
    final String url =
        "https://api.themoviedb.org/3/movie/$movieID/videos?api_key=$apiKey";

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseDecode = jsonDecode(response.body) as Map<String, dynamic>;
      final responseData = responseDecode["results"] as List;
      print("asdasda ${responseData} asdasdas");
      return responseData.map((kkk) => MovieTrailerList.fromJson(kkk)).toList();
    } else {
      throw Exception("Error to load Data");
    }
  }

  Future<MovieTrailer> getMovieTrailer(String movieID) async {
    final String uri =
        "https://api.themoviedb.org/3/movie/$movieID/videos?api_key=$apiKey";

    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      // final decodeData = jsonDecode(response.body);
      // final respon = decodeData['cast'];
      // return respon.map((e) => MovieCredits?.fromJson(e)).toList();
      return MovieTrailer.fromJson(jsonDecode(response.body));
    }

    var responResult = jsonDecode(response.body);

    return responResult;
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
}

// Future<MovieTrailer> getTrailers(String movieId) async {
//   const apiKey = 'b0b1b7542963befc2f848ce363e5c4ab';
//   final url = Uri.parse(
//       'https://api.themoviedb.org/3/movie/$movieId/trailers?api_key=$apiKey');

//   final response = await http.get(url);

//   if (response.statusCode == 200) {
//     return MovieTrailer.fromJson(jsonDecode(response.body)['result']);
//   }

//   var responseReturn = jsonDecode(response.body)['results'];

//   return responseReturn;
// }

// Future<List<MovieTrailer>> getTrailers(String movieId) async {
//   const apiKey = 'b0b1b7542963befc2f848ce363e5c4ab';
//   final url = Uri.parse(
//       'https://api.themoviedb.org/3/movie/$movieId/trailers?api_key=$apiKey');
//   final response = await http.get(url);
//   final data = jsonDecode(response.body);
//   final trailers = (data['results'] as List)
//       .map((json) => MovieTrailer.fromJson(json))
//       .toList();
//   return trailers;
// }

// Future<void> _fetchTrailer() async {
//   final String apiKey = "b0b1b7542963befc2f848ce363e5c4ab";
//   final String baseURL =
//       "https://api.themoviedb.org/3/movie/${widget.movieID}/videos?api_key=";

//   final uri = baseURL + apiKey;

//   http.Response response = await http.get(Uri.parse(uri));

//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = json.decode(response.body);
//     final List<dynamic> results = data['results'];
//     if (results.isNotEmpty) {
//       final String trailerKey = results[0]['key'];
//       final videoUrl = 'https://www.youtube.com/watch?v=$trailerKey';
//       _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
//       await Future.wait(_controller.initialize());
//     }
//   } else {
//     throw Exception('Failed to load trailers');
//   }
// }

// class HttpService {
//   final String apiKey = "b0b1b7542963befc2f848ce363e5c4ab";
//   final String baseUrl = "https://api.themoviedb.org/3/movie/popular?api_key=";

//   Future<Movie?> getPopular() async {
//     final String uri = baseUrl + apiKey;

//     http.Response result = await http.get(Uri.parse(uri));
//     if (result.statusCode == HttpStatus.ok) {
//       final decodeData = json.decode(result.body)["results"];
//       print(decodeData);
//       return decodeData.map((movie) => Movie.fromJson(movie)).toList();
//       // final jsonResponse = json.decode(result.body);
//       // final moviesMap = jsonResponse['result'] as List;
//       // List movies = moviesMap.map((movie) => Movie.fromJson(movie)).toList();
//       // return movies;
//     } else {
//       print("gagal");
//       // throw Exception("Error");
//       return null;
//     }
//   }
// }
