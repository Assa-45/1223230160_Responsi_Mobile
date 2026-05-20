import 'package:flutter/foundation.dart';
import '../models/anime_model.dart';
import '../services/db_service.dart';
import '../services/session_service.dart';

class AppState extends ChangeNotifier {
  final _db = DatabaseService();
  final _session = SessionService();

  String? _currentUsername;
  bool _isLoggedIn = false;

  List<FavItem> _fav = [];
  bool isLoadingFav = false;

  String? get currentUsername => _currentUsername;
  bool get isLoggedIn => _isLoggedIn;
  
  List<FavItem> get currentCart => _fav;
  int get favItemCount => _fav.fold(0, (s, i) => s + i.quantity);

  Future<void> tryAutoLogin() async {
    final savedUsername = await _session.getSavedUsername();
    if (savedUsername != null) {
      _currentUsername = savedUsername;
      _isLoggedIn = true;
      await _loadFav();
      notifyListeners();
    }
  }

  // ─── LOGIN 
  Future<void> login(String username) async {
    _currentUsername = username;
    _isLoggedIn = true;
    await _session.saveSession(username); // simpan ke SharedPreferences
    await _loadFav();                     // load fav dari Sembast
    notifyListeners();
  }

  // ─── LOGOUT 
  Future<void> logout() async {
    await _session.clearSession(); // hapus dari SharedPreferences
    _currentUsername = null;
    _isLoggedIn = false;
    _fav = [];
    notifyListeners();
  }

  // ─── LOAD FAV dari Sembast 
  Future<void> _loadFav() async {
    if (_currentUsername == null) return;

    isLoadingFav = true;
    notifyListeners();

    final rawItems = await _db.getFav(_currentUsername!);

    // Konversi Map → FavItem
    _fav = rawItems.map((map) {
      final anime = Anime.fromJson(map['anime'] as Map<String, dynamic>);
      return FavItem(
        anime: anime,
        username: map['username'] as String,
        quantity: map['quantity'] as int,
      );
    }).toList();

    isLoadingFav = false;
    notifyListeners();
  }

  // ─── SIMPAN FAV ke Sembast 
  Future<void> _persistFav() async {
    if (_currentUsername == null) return;

    // Konversi FavItem → Map untuk disimpan
    final rawItems = _fav.map((item) => {
      'username': item.username,
      'anime': {
        'id': item.anime.id,
        'title': item.anime.title,
        'description': item.anime.synopsis,
        'rating': item.anime.rating,
        'episode': item.anime.episode,
        'thumbnail': item.anime.thumbnail,
        'images': item.anime.images,
      },
    }).toList();

    await _db.saveCart(_currentUsername!, rawItems);
  }

  // ─── ADD TO FAV
  Future<void> addToFav(Anime anime, int quantity) async {
    if (_currentUsername == null) return;
    final existingIndex = _fav.indexWhere((i) => i.anime.id == anime.id);
    _fav.add(FavItem(
        anime: anime,
        username: _currentUsername!,
        quantity: quantity
    ));

    notifyListeners();
    await _persistFav(); // langsung simpan ke Sembast
  }

  // ─── REMOVE FROM FAV
  Future<void> removeFromFav(int animeId) async {
    _fav.removeWhere((i) => i.anime.id == animeId);
    notifyListeners();
    await _persistFav();
  }
}