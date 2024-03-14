import 'dart:convert';
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

Future<MovieTopRate> getMovieTopRate() async {
  final String apiKey = "b0b1b7542963befc2f848ce363e5c4ab";
  final String baseUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=";

  final uri = baseUrl + apiKey;

  http.Response response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    return MovieTopRate.fromJson(jsonDecode(response.body));
  }

  var responseReturn = jsonDecode(response.body);

  return responseReturn;
}

// Future<List<Movie>> getMovie() async {
//   final String apiKey = "b0b1b7542963befc2f848ce363e5c4ab";
//   final String baseUrl = "https://api.themoviedb.org/3/movie/popular?api_key=";

//   final uri = baseUrl + apiKey;

//   http.Response response = await http.get(Uri.parse(uri));

//   if (response.statusCode == 200) {
//     final List movies = json.decode(response.body);
//     return movies.map((json) => Movie.fromJson(json)).toList();
//   }

//   var responseReturn = jsonDecode(response.body);

//   return responseReturn;
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
