import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/anime_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Consumer<AppState>(
          builder: (context, appState, _) {
            final fav = appState.currentFav;
            final username = appState.currentUsername ?? '';

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Favorite Anime',
                              style: GoogleFonts.dmSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '@$username · ${fav.length} item',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Body
                Expanded(
                  child: fav.isEmpty
                      ? _buildEmpty(context)
                      : _buildFavList(context, appState, fav),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.white.withOpacity(0.07), width: 1),
            ),
            child: const Icon(
              Icons.movie_outlined,
              color: Colors.white24,
              size: 44,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Anime Kosong',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada anime yang ditambahkan.\nYuk mulai tonton!',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.white38,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavList(
      BuildContext context, AppState appState, List<FavItem> cart) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cart.length,
      itemBuilder: (_, i) => _FavItemCard(
        item: cart[i],
        onDelete: () {
          appState.removeFromFav(cart[i].anime.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              backgroundColor: const Color(0xFF1E1E32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              content: Row(
                children: [
                  const Icon(Icons.delete_outline_rounded,
                      color: Colors.redAccent, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    'Anime dihapus dari favorit',
                    style:
                        GoogleFonts.dmSans(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}

class _FavItemCard extends StatelessWidget {
  final FavItem item;
  final VoidCallback onDelete;

  const _FavItemCard({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final anime = item.anime;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              anime.thumbnail,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: const Color(0xFF1A1A2E),
                child: const Icon(Icons.image_not_supported_outlined,
                    color: Colors.white24, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anime.title,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 13),
                  const SizedBox(width: 3),
                  Text(
                    anime.rating.toStringAsFixed(1),
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Delete button
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1A2E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    'Hapus Item?',
                    style: GoogleFonts.dmSans(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  content: Text(
                    'Hapus "${anime.title}" dari favorit?',
                    style: GoogleFonts.dmSans(color: Colors.white60),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal',
                          style: GoogleFonts.dmSans(color: Colors.white54)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                      child: Text(
                        'Hapus',
                        style: GoogleFonts.dmSans(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: Colors.redAccent, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}