import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pahlawan.dart';

class PahlawanDatabase {
  // Singleton instance
  static final PahlawanDatabase instance = PahlawanDatabase._init();

  // Private database instance
  static Database? _database;

  // Private constructor
  PahlawanDatabase._init();

  // Getter untuk database
  Future<Database> get database async {
    // Jika database sudah dibuat, kembalikan database yang ada
    if (_database != null) return _database!;

    // Jika database belum dibuat, inisialisasi database
    _database = await _initDB('pahlawan.db');
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDB(String filePath) async {
    // Mendapatkan path direktori database
    final dbPath = await getDatabasesPath();
    // Menggabungkan nama file dengan path direktori database
    final path = join(dbPath, filePath);

    // Membuka database atau membuat database jika belum ada
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Membuat tabel pahlawans saat pembuatan database pertama kali
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pahlawans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        category TEXT,
        description TEXT,
        imagePath TEXT
      )
    ''');
  }

  // Memperbarui tabel pahlawans saat ada pembaruan versi database
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Logic untuk pembaruan database bisa ditambahkan di sini
  }

  // Menyisipkan data pahlawan ke dalam database
  Future<void> insertPahlawan(Pahlawan pahlawan) async {
    final db = await instance.database;
    await db.insert('pahlawans', pahlawan.toMap());
  }

  // Mendapatkan semua data pahlawan dari database
  Future<List<Pahlawan>> getAllPahlawans() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('pahlawans');
    return List.generate(maps.length, (i) {
      return Pahlawan(
        id: maps[i]['id'],
        name: maps[i]['name'],
        category: maps[i]['category'],
        description: maps[i]['description'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }

  // Mendapatkan data pahlawan berdasarkan ID
  Future<Pahlawan?> getPahlawanById(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pahlawans',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Pahlawan(
        id: maps[0]['id'],
        name: maps[0]['name'],
        category: maps[0]['category'],
        description: maps[0]['description'],
        imagePath: maps[0]['imagePath'],
      );
    }
    return null;
  }

  // Mengupdate data pahlawan dalam database
  Future<void> updatePahlawan(Pahlawan pahlawan) async {
    final db = await instance.database;
    await db.update(
      'pahlawans',
      pahlawan.toMap(),
      where: 'id = ?',
      whereArgs: [pahlawan.id],
    );
  }

  // Menghapus pahlawan berdasarkan ID dari database
  Future<void> deletePahlawan(int id) async {
    final db = await instance.database;
    await db.delete(
      'pahlawans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
