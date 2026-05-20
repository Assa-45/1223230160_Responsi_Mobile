import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';  
import 'package:sembast_web/sembast_web.dart';

class DatabaseService {
  // satu instance saja selama app jalan
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  // Store untuk fav, key = username
  final _favStore = stringMapStoreFactory.store('favorite');

  // ─── INISIALISASI 
  Future<Database> get database async {
    // Kalau sudah dibuka, langsung return
    if (_db != null) return _db!;

    if (kIsWeb) {
      // Web: simpan di IndexedDB browser
      _db = await databaseFactoryWeb.openDatabase('keripikroll.db');
    } else {
      // Mobile/Desktop: simpan di file lokal
      final dir = await getApplicationDocumentsDirectory();
      final path = join(dir.path, 'keripikroll.db');
      _db = await databaseFactoryIo.openDatabase(path);
    }

    return _db!;
  }

  // ─── FAVORITE LOGIC

  // Simpan fav milik user tertentu
  Future<void> saveCart(String username, List<Map<String, dynamic>> items) async {
    final db = await database;
    // Key = username, value = map berisi list items
    await _favStore.record(username).put(db, {'items': items});
  }

  // Ambil fav milik user tertentu
  Future<List<Map<String, dynamic>>> getFav(String username) async {
    final db = await database;
    final record = await _favStore.record(username).get(db);

    if (record == null) return []; // kalau user belum punya cart

    final items = record['items'] as List? ?? [];
    return items.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  // Hapus seluruh fav milik user
  Future<void> clearFav(String username) async {
    final db = await database;
    await _favStore.record(username).delete(db);
  }

  // Tutup koneksi database
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}