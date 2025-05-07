import 'package:mysql1/mysql1.dart';

class BaseDatos {
  var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
  );
  static installBBDD() async {
    var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'proyectodart',
    );
    var conn = await MySqlConnection.connect(settings);
    try {
      await _crearBBDD(conn);
      await _crearTablaUsuarios(conn);
      await _crearTablaPokemon(conn);
    } catch (e) {
      print("Error durante la configuración inicial: $e");
    } finally {
      await conn.close();
    }
  }

  // Crear la base de datos si no existe / FUNCION
  static _crearBBDD(MySqlConnection conn) async {
    await conn.query('USE proyectodart;');
    print("Conectado a la base de datos 'proyectodart'.");
    await conn.query('CREATE DATABASE IF NOT EXISTS proyectodart');
    print("Base de datos 'proyectodart' creada o ya existente.");
  }

  // Crear la tabla de usuarios si no existe
  static _crearTablaUsuarios(MySqlConnection conn) async {
    await conn.query('USE proyectodart;');
    print("Conectado a la base de datos 'proyectodart'.");

    await conn.query('''
      CREATE TABLE IF NOT EXISTS usuarios (
        idusuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(10) NOT NULL
      );
    ''');
    print("Tabla 'usuarios' creada o ya existente.");
  }

  static _crearTablaPokemon(MySqlConnection conn) async {
    try {
      await conn.query('''
      CREATE TABLE IF NOT EXISTS pokemon (
        idpokemon INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
      );
    ''');
      print("Tabla 'pokemon' creada o ya existente.");
    } catch (e) {
      print("Error durante la configuración inicial: $e");
      return;
    } finally {
      // Cerrar la conexión inicial
      await conn?.close();
    }
  }
}
