import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/anime_model.dart';
import '../providers/app_state.dart';

class AnimeDetailPage extends StatefulWidget {
  final Anime anime;
  const AnimeDetailPage({super.key, required this.anime});

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  Anime get a => widget.anime;

  void _addToFav(BuildContext context) {
    context.read<AppState>().addToFav(a, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF1E1E32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            const Icon(Icons.favorite_rounded, color: Color(0xFF6C63FF), size: 20),
            const SizedBox(width: 10),
            Text(
              'Ditambahkan ke Favorit!',
              style: GoogleFonts.dmSans(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        slivers: [
          // App Bar + Cover Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D0D),
            title: Text(
              'Detail',
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  a.thumbnail.isNotEmpty
                      ? Image.network(
                          a.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF1A1A2E),
                            child: const Icon(Icons.image_not_supported_outlined,
                                color: Colors.white24, size: 48),
                          ),
                        )
                      : Container(color: const Color(0xFF1A1A2E)),

                  // Gradient overlay bawah
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF0D0D0D).withOpacity(0.95),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    a.title,
                    style: GoogleFonts.dmSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFC107), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        a.rating.toStringAsFixed(2),
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Age rating & episodes
                  Text(
                    '${a.ageRating.isNotEmpty ? a.ageRating : 'N/A'} • ${a.episode > 0 ? a.episode : 'N/A'} Episodes',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Nonton + Favorit
                  Row(
                    children: [
                      // Tombol Nonton (statis)
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8470A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.play_arrow_rounded, size: 22),
                            label: Text(
                              'Nonton',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Tombol Favorit
                      Consumer<AppState>(
                        builder: (_, appState, __) {
                          final isFav = appState.currentFav
                              .any((f) => f.anime.id == a.id);
                          return GestureDetector(
                            onTap: () => _addToFav(context),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A2E),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: isFav
                                    ? Colors.redAccent
                                    : Colors.white54,
                                size: 22,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Overview
                  Text(
                    'Overview',
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    a.synopsis.isNotEmpty ? a.synopsis : 'Tidak ada sinopsis.',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.white60,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}