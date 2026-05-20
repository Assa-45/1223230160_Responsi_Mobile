class Anime {
  final int id;
  final String title;
  final String synopsis;
  final double rating;
  final int episode;
  final String thumbnail;
  final String images;

  Anime({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.rating,
    required this.episode,
    required this.thumbnail,
    required this.images,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      title: json['canonicalTitle'] ?? '',
      synopsis: json['synopsis'] ?? '',
      rating: (json['averageRating'] ?? 0).toDouble(),
      episode: json['episode'] ?? 0,
      images: json['posterImage'] ?? '',
      thumbnail: json['coverImage'] ?? '',
    );
  }
}

class FavItem {
  final Anime anime;
  final String username;
  int quantity;

  FavItem({
    required this.anime,
    required this.username,
    required this.quantity,
  });
}