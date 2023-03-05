import 'dart:convert';

class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;

  Movie(
      {required this.title,
      required this.year,
      required this.imdbID,
      required this.type,
      required this.poster});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      imdbID: json['imdbID'],
      type: json['Type'],
      poster: json['Poster'],
    );
  }
  @override
  String toString() {
    return 'Movie{title: $title, year: $year, imdbId: $imdbID, type: $type, poster: $poster}';
  }
}

List<Movie> parseMovies(String responseBody) {
  final parsed = jsonDecode(responseBody);
  List<dynamic> moviesJson = parsed['Search'];
  return moviesJson.map((movieJson) => Movie.fromJson(movieJson)).toList();
}
