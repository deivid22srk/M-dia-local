class MediaItem {
  final String id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? rating;
  final String? releaseDate;
  final String mediaType; // 'movie' ou 'tv'
  final String? filePath;
  final Duration? duration;
  final int? seasonNumber;
  final int? episodeNumber;

  MediaItem({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.rating,
    this.releaseDate,
    required this.mediaType,
    this.filePath,
    this.duration,
    this.seasonNumber,
    this.episodeNumber,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json, {String? filePath}) {
    return MediaItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? 'Sem título',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      rating: json['vote_average']?.toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'],
      mediaType: json['media_type'] ?? (json['title'] != null ? 'movie' : 'tv'),
      filePath: filePath,
    );
  }

  MediaItem copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? rating,
    String? releaseDate,
    String? mediaType,
    String? filePath,
    Duration? duration,
    int? seasonNumber,
    int? episodeNumber,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      rating: rating ?? this.rating,
      releaseDate: releaseDate ?? this.releaseDate,
      mediaType: mediaType ?? this.mediaType,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
    );
  }
}
