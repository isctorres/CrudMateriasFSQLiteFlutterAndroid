import 'dart:io';

import 'package:consumir_web_api/models/materia.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper{

  static final _nombreBD = "MATERIASBD";
  static final _versionBD = 1;
  static final _nombreTBL = "tbl_materias";

  /*DataBaseHelper._privateConstructor();
  static final DataBaseHelper instancia = DataBaseHelper._privateConstructor();*/

  static Database _database;

   Future<Database> get database async{
    if( _database != null ) return _database;
    _database = await _initDataBase();
    return _database;
  }

  //Future<Database> _initDataBase() async{
  _initDataBase() async{
    Directory carpeta = await getApplicationDocumentsDirectory();
    String ruta = join(carpeta.path, _nombreBD);
    return await openDatabase(
        ruta,
        version: _versionBD,
        onCreate: _crearTabla
    );
  }

  _crearTabla(Database db, int version) async {
    await db.execute("CREATE TABLE $_nombreTBL (id INTEGER PRIMARY KEY, nombre VARCHAR(50), profesor VARCHAR(50), cuatrimestre VARCHAR(25), horario VARCHAR(25))");
  }

  Future<int> insertar(Map<String, dynamic> row) async{
    var dbClient = await database;
    return await dbClient.insert(_nombreTBL, row);
  }

  Future<int> actualizar(Map<String, dynamic> row) async{
    var dbClient = await database;
    return await dbClient.update(_nombreTBL, row, where: 'id = ?', whereArgs: [row['id']]);
  }

  Future<int> eliminar(int id) async{
    var dbClient = await database;
    return await dbClient.delete(_nombreTBL, where: 'id = ?', whereArgs: [id] );
  }

  Future<List<Materia>> listarTodos() async{
    var dbClient = await database;
    var result = await dbClient.query(_nombreTBL);
    return (result).map((itemWord) => Materia.fromJson(itemWord)).toList();
  }

  Future<int> noRegistros() async{
    return Sqflite.firstIntValue(await _database.rawQuery('SELECT COUNT(*) FROM $_nombreTBL'));
  }
}