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

  /* INACABADO TODAVIA HABILIDAD
  obtenerHabilidad(String nombre) async {
    Uri url2 = Uri.parse('https://pokeapi.co/api/v2/ability/$nombre');
    var respuesta = await http.get(url2);
    if (respuesta.statusCode == 200) {
      Habilidad habilidad = Habilidad.fromAPI(json.decode(respuesta.body));
      return habilidad;
    } else
      return;
  } */
}

  /*
  // Hacer funciones/metodos para iniciar bbdd
void main() async {
  MySqlConnection? conn;
  try {
    // Configuración de la conexión a la base de datos
    var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
    );

    // Conectar a MySQL
    conn = await MySqlConnection.connect(settings);
    print("Conectado a MySQL.");

    // Crear la base de datos si no existe
    await conn.query('CREATE DATABASE IF NOT EXISTS proyectodart');
    print("Base de datos 'proyectodart' creada o ya existente.");

    // Usar la base de datos
    await conn.query('USE proyectodart;');
    print("Conectado a la base de datos 'proyectodart'.");

    // Crear la tabla de usuarios si no existe
    await conn.query('''
      CREATE TABLE IF NOT EXISTS usuarios (
        idusuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(10) NOT NULL
      );
    ''');
    print("Tabla 'usuarios' creada o ya existente.");
  } catch (e) {
    print("Error durante la configuración inicial: $e");
    return;
  } finally {
    // Cerrar la conexión inicial
  }

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

  // Menú principal
  Usuario usuario = Usuario();
  int? opcion;

  do {
    print("\n¿Bienvenido, quieres Registrarte o Iniciar sesión?");
    stdout.writeln("1 - Registrarse | 2 - Iniciar sesión | 3 - Salir");
    String respuesta = stdin.readLineSync() ?? "ERROR";
    opcion = int.tryParse(respuesta) ?? 0;

    switch (opcion) {
      case 1:
        await registrarUsuario();
        break;

      case 2:
        bool inicioExitoso = await iniciarSesion();
        if (inicioExitoso) {
          print("Inicio de sesión exitoso. ¡Bienvenido!");
          await menuPrincipal(usuario);
        } else {
          print("Nombre de usuario o contraseña incorrectos.");
        }
        break;

      case 3:
        print("Saliendo del programa...");
        break;

      default:
        print("Opción no válida. Inténtalo de nuevo.");
        break;
    }
  } while (opcion != 3);
}

// Función para registrar un nuevo usuario
Future<void> registrarUsuario() async {
  MySqlConnection? conn;
  try {
    // Conectar a la base de datos
    var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'proyectodart',
    );
    conn = await MySqlConnection.connect(settings);

    // Solicitar datos al usuario
    print("Introduce tu nombre de usuario:");
    String nombre = stdin.readLineSync() ?? "";
    print("Introduce tu contraseña):");
    String password = stdin.readLineSync() ?? "";

    // Verificar si el usuario ya existe
    var resultado = await conn.query(
      'SELECT * FROM usuarios WHERE nombre = ?',
      [nombre],
    );

    if (resultado.isNotEmpty) {
      print("El nombre de usuario ya existe. Por favor, elige otro.");
      return;
    }

    // Insertar el nuevo usuario en la base de datos
    await conn.query(
      'INSERT INTO usuarios (nombre, password) VALUES (?, ?)',
      [nombre, password],
    );
    print("Usuario registrado exitosamente.");
  } catch (e) {
    print("Error al registrar el usuario: $e");
  } finally {
    // Cerrar la conexión
    await conn?.close();
  }
}

// Función para iniciar sesión
Future<bool> iniciarSesion() async {
  MySqlConnection? conn;
  try {
    // Conectar a la base de datos
    var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'proyectodart',
    );
    conn = await MySqlConnection.connect(settings);

    // Solicitar datos al usuario
    print("Introduce tu nombre de usuario:");
    String nombre = stdin.readLineSync() ?? "";
    print("Introduce tu contraseña:");
    String password = stdin.readLineSync() ?? "";

    // Verificar si el usuario y la contraseña coinciden
    var resultado = await conn.query(
      'SELECT * FROM usuarios WHERE nombre = ? AND password = ?',
      [nombre, password],
    );

    if (resultado.isNotEmpty) {
      return true; // Inicio de sesión exitoso
    } else {
      return false; // Usuario o contraseña incorrectos
    }
  } catch (e) {
    print("Error al iniciar sesión: $e");
    return false;
  } finally {
    // Cerrar la conexión
    await conn?.close();
  }
}

// Menú principal después del inicio de sesión
Future<void> menuPrincipal(Usuario usuario) async {
  int? opcion;

  do {
    print("\n¿Qué quieres hacer?");
    stdout
        .writeln("1 - Acceder a la Pokedex | 2 - EspacioEnBlanco | 3 - Salir");
    String respuesta = stdin.readLineSync() ?? "ERROR";
    opcion = int.tryParse(respuesta) ?? 0;

    switch (opcion) {
      case 1:
        break;

      case 2:
        break;

      case 3:
        print("Saliendo del menú principal...");
        break;

      default:
        print("Opción no válida. Inténtalo de nuevo.");
        break;
    }
  } while (opcion != 3); */
