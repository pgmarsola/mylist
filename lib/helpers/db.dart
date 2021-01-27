import 'dart:io';

import 'package:mylist/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String tabelaNome = 'tabela_tarefas';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }

    return _database;
  }

  Future<Database> initDb() async {
    Directory diretorio = await getApplicationDocumentsDirectory();
    String path = diretorio.path + 'tarefas.db';

    var dbTarefas = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTarefas;
  }

  void _createDb(Database db, int versao) async {
    await db.execute('CREATE TABLE $tabelaNome('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTitle TEXT,'
        '$colDescription TEXT,'
        '$colDate TEXT);');
  }

  Future<List<Map<String, dynamic>>> getNotesMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery("SELECT * FROM $tabelaNome");
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(tabelaNome, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note, int id) async {
    var db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE $tabelaNome SET $colTitle = '${note.title}', $colDescription = '${note.description}', $colDate = '${note.date}' WHERE $colId = '$id'");
    return result;
  }

  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tabelaNome WHERE $colId = $id');
    return result;
  }

  Future<List<Note>> getListNotes() async {
    var noteMapList = await getNotesMapList();
    int count = noteMapList.length;
    List<Note> listNote = <Note>[];
    for (int i = 0; i < count; i++) {
      listNote.add(Note.fromMapObject(noteMapList[i]));
    }
    return listNote;
  }
}
