import 'dart:convert';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTrailerModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieModelApi.dart';
import 'package:Itil.Co/src/SetUp/modelsAPI/MovieTopRateModelApi.dart';
import 'package:http/http.dart' as http;

Future<Movie> getMovie() async {
  final String apiKey = "b0b1b7542963befc2f848ce363e5c4ab";
  final String baseUrl = "https://api.themoviedb.org/3/movie/popular?api_key=";

  final uri = baseUrl + apiKey;

  http.Response response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    return Movie.fromJson(jsonDecode(response.body));
  }

  var responseReturn = jsonDecode(response.body);

  return responseReturn;
}

Future<MovieTopRated> getMovieTopRate() async {
  final String apiKey = "b0b1b7542963befc2f848ce363e5c4ab";
  final String baseUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=";

  final uri = baseUrl + apiKey;

  http.Response response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    return MovieTopRated.fromJson(jsonDecode(response.body));
  }

  var responseReturn = jsonDecode(response.body);

  return responseReturn;
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
