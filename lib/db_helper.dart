import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Produto.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();

  factory DbHelper() => _instance;

  static Database? _database;

  //Future<Database> get database async => _database ??= await _initDatabase();

  /* Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }*/

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  DbHelper._internal();

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'lista_de_compras.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE produtos (
            id INTEGER PRIMARY KEY,
            nome TEXT NOT NULL,
            marca TEXT NOT NULL,
            quantidade INTEGER NOT NULL
          )
          ''',
        );
      },
    );
  }

  Future<int> inserirProduto(Produto produto) async {
    final db = await database;

    return db!.insert(
      'produtos',
      produto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Produto>> obterTodosOsProdutos() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db!.query('produtos');

    return List.generate(
      maps.length,
      (i) => Produto.fromMap(maps[i]),
    );
  }

  Future<int> atualizarProduto(Produto produto) async {
    final db = await database;

    return db!.update(
      'produtos',
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<int> excluirProduto(int id) async {
    final db = await database;

    return db!.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
