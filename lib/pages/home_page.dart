import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/anime_model.dart';
import '../providers/app_state.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Anime> _animes = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchAnimes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAnimes() async {
    if(!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final animes = await ApiService().fetchAnimes();

      if(!mounted) return;
      setState(() {
        _animes = animes;
        _isLoading = false;
      });
    } catch (e) {
      if(!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Anime> get _filteredAnimes {
    return _animes.where((a) {
      final matchSearch = _searchQuery.isEmpty ||
          a.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favCount = appState.favItemCount;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(appState.currentUsername ?? '', favCount),

            // Search bar
            _buildSearchBar(),

            SizedBox(height: 24),

            // Anime grid
            Expanded(
              child: _isLoading
                  ? _buildShimmer()
                  : _error != null
                      ? _buildError()
                      : _filteredAnimes.isEmpty
                          ? _buildEmpty()
                          : _buildAnimeGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String username, int favCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo,',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.white38,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  username,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Fav button
          Stack(
            clipBehavior: Clip.none,
            children: [
              if (favCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$favCount',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.dmSans(color: Colors.white, fontSize: 14),
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: 'Cari judul anime',
          hintStyle: GoogleFonts.dmSans(color: Colors.white24, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: Colors.white38, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFF1A1A2E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildAnimeGrid() {
    final animes = _filteredAnimes;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: animes.length,
        itemBuilder: (_, i) => _AnimeCard(anime: animes[i]),
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF1A1A2E),
        highlightColor: const Color(0xFF2A2A40),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: 6,
          itemBuilder: (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white24, size: 48),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat anime',
            style: GoogleFonts.dmSans(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchAnimes,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text('Coba Lagi', style: GoogleFonts.dmSans(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, color: Colors.white24, size: 48),
          const SizedBox(height: 16),
          Text(
            'Anime tidak ditemukan',
            style: GoogleFonts.dmSans(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _AnimeCard extends StatelessWidget {
  final Anime anime;
  const _AnimeCard({required this.anime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnimeDetailPage(anime: anime),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF13131F),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      anime.images,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Icon(Icons.image_not_supported_outlined,
                            color: Colors.white24),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anime.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3),
                         Text(
                          '${anime.ageRating} • ${anime.episode} Episodes' ,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.white54,
                          ),
                        ),
                        SizedBox(height: 3),
                        // Rating 
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}