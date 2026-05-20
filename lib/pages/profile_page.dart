import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final username = appState.currentUsername ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header hero section
              _buildHeroSection(username),

              const SizedBox(height: 28),

              // Account info section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildAccountCard(username),
              ),

              const SizedBox(height: 24),

              // Kesan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildKesanCard(),
              ),

              const SizedBox(height: 16),

              // Pesan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildPesanCard(),
              ),

              const SizedBox(height: 16),

              // Logout button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildLogoutButton(context, appState),
              ),

              const SizedBox(height: 32),

              // Footer
              Text(
                'Keripikroll v1.0.0 · Made with Luv',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: Colors.white24,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(String username) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF13131F), Color(0xFF0D0D0D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Color(0xFFFF6584)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: GoogleFonts.dmSans(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Username
          Text(
            username,
            style: GoogleFonts.dmSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded,
                    color: Colors.redAccent, size: 14),
                const SizedBox(width: 5),
                Text(
                  'Member Keripikroll',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int cartItems, int uniqueProducts) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          _buildStatItem('$cartItems', 'Total Item\ndi Keranjang'),
          _buildStatDivider(),
          _buildStatItem('$uniqueProducts', 'Produk\nUnik'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: Colors.white38,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.07),
    );
  }

  Widget _buildKesanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: Colors.redAccent, size: 18),
              const SizedBox(width: 8),
              Text(
                'Kesan',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Proyek ini seru banget dikerjain karena banyak hal baru yang aku temuin di luar ekspektasi,' 
            'mulai dari manage state pake Provider, fetching data dari API eksternal, sampe ngulik kompatibilitas database buat web yang ternyata nggak sesimpel yang  kubayangin.',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.white60,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPesanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mail_outline_rounded,
                  color: Colors.redAccent, size: 18),
              const SizedBox(width: 8),
              Text(
                'Pesan',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Jangan langsung comit ke satu teknologi cuma karena dia populer atau banyak tutorialnya, karena belum tentu cocok sama kebutuhan project, kayak kasusnya SQLite vs Hive vs Sembast ini.',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.white60,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(String username) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline_rounded,
                  color: Colors.redAccent, size: 18),
              const SizedBox(width: 8),
              Text(
                'Informasi Akun',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildInfoRow(Icons.account_circle_outlined, 'Username', username),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.shield_outlined, 'Status', 'Aktif'),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.calendar_today_outlined, 'Bergabung',
              'Mei 2026'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 16),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white38),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppState appState) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: const Color(0xFF1A1A2E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Logout?',
                style: GoogleFonts.dmSans(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
              content: Text(
                'Kamu yakin ingin keluar dari akun ini?',
                style: GoogleFonts.dmSans(color: Colors.white60),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Batal',
                      style:
                          GoogleFonts.dmSans(color: Colors.white54)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    appState.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoginPage(),
                        transitionsBuilder: (_, anim, __, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration:
                            const Duration(milliseconds: 400),
                      ),
                      (_) => false,
                    );
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.dmSans(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: BorderSide(color: Colors.red.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, size: 18),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}