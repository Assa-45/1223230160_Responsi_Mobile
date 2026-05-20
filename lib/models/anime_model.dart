class Anime {
  final int id;
  final String title;
  final String synopsis;
  final String ageRating;
  final double rating;
  final int episode;
  final String images;
  final String thumbnail;

  Anime({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.rating,
    required this.ageRating,
    required this.episode,
    required this.images,
    required this.thumbnail,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>;

    return Anime(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: (attributes['titles'] as Map?)?['en_jp'] ?? 'No Title',
      synopsis: attributes['synopsis'] ?? '',
      ageRating: attributes['ageRating'] ?? '',
      rating: double.tryParse(attributes['averageRating'] ?? '0') ?? 0.0,
      episode: int.tryParse(attributes['episodeCount']?.toString() ?? 'N/A') ?? 0,
      images: (attributes['posterImage'] as Map?)?['medium'] ?? '',
      thumbnail: (attributes['coverImage'] as Map?)?['small'] ?? '',
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