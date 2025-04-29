import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'info.dart';
import 'pokeapi_service.dart';

class Menu {
  static Future<void> menuInicio() async {
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

      int opcion;
      do {
        print("\n¿Bienvenido, quieres Registrarte o Iniciar sesión?");
        stdout.writeln("1 - Registrarse | 2 - Iniciar sesión | 3 - Salir");
        String respuesta = stdin.readLineSync() ?? "ERROR";
        opcion = int.tryParse(respuesta) ?? 0;

        switch (opcion) {
          case 1:
            await registrarUsuario(conn);
            break;

          case 2:
            bool sesionIniciada = await iniciarSesion(conn);
            if (sesionIniciada) {
              await menuSecond(conn);
            } else {
              print("Usuario o contraseña incorrectos.");
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
    } catch (e) {
      print("Error en el menú principal: $e");
    } finally {
      // Cerrar la conexión
      await conn?.close();
    }
  }

  static Future<void> registrarUsuario(MySqlConnection conn) async {
    try {
      // Solicitar datos al usuario
      print("Introduce tu nombre de usuario:");
      String nombre = stdin.readLineSync() ?? "";
      print("Introduce tu contraseña:");
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
    }
  }

  static Future<void> menuSecond(MySqlConnection conn) async {
    int? opcion;
    do {
      print("\n¿Qué quieres hacer?");
      stdout
          .writeln("1 - Acceder a la Pokedex | 2 - Buscar Pokémon | 3 - Salir");
      String respuesta = stdin.readLineSync() ?? "ERROR";
      opcion = int.tryParse(respuesta) ?? 0;

      switch (opcion) {
        case 1:
          await mostrarPokedex(conn);
          break;

        case 2:
          await buscarPokemon();
          break;

        case 3:
          print("Saliendo del menú secundario...");
          break;

        default:
          print("Opción no válida. Inténtalo de nuevo.");
          break;
      }
    } while (opcion != 3);
  }

  static Future<void> mostrarPokedex(MySqlConnection conn) async {
    try {
      print("\nMostrando lista de Pokémon...");
      final pokemonList = await PokeApiService.getPokemonList(20);

      for (var pokemon in pokemonList) {
        print("- ${pokemon['name']}");
      }

      print("\n¿Quieres ver detalles de algún Pokémon? (s/n)");
      String respuesta = stdin.readLineSync()?.toLowerCase() ?? "n";

      if (respuesta == "s") {
        print("Introduce el nombre del Pokémon:");
        String nombre = stdin.readLineSync()?.toLowerCase() ?? "";
        await mostrarDetallesPokemon(nombre, conn);
      }
    } catch (e) {
      print("Error al mostrar la Pokédex: $e");
    }
  }

  static Future<void> buscarPokemon() async {
    try {
      print("\nIntroduce el nombre o ID del Pokémon que buscas:");
      String identifier = stdin.readLineSync()?.trim() ?? "";

      final pokemonData = await PokeApiService.getPokemonData(identifier);
      final pokemon = PokeApiService.mapApiDataToPokemon(pokemonData);

      print("\nInformación de ${pokemon.nombre}:");
      print("Vida: ${pokemon.vida}");
      print("Ataque: ${pokemon.ataque}");
      print("Defensa: ${pokemon.defensa}");
      print("Ataque Especial: ${pokemon.ataqueEspecial}");
      print("Defensa Especial: ${pokemon.defensaEspecial}");
      print("Velocidad: ${pokemon.velocidad}");
      print("Habilidades: ${pokemon.habilidades.join(", ")}");
      print("Habilidad principal: ${pokemon.habilidad}");
    } catch (e) {
      print("Error al buscar el Pokémon: $e");
    }
  }

  static Future<void> mostrarDetallesPokemon(
      String nombre, MySqlConnection conn) async {
    try {
      final pokemonData = await PokeApiService.getPokemonData(nombre);
      final pokemon = PokeApiService.mapApiDataToPokemon(pokemonData);

      print("\nDetalles de ${pokemon.nombre}:");
      print("Estadísticas:");
      print("- Vida: ${pokemon.vida}");
      print("- Ataque: ${pokemon.ataque}");
      print("- Defensa: ${pokemon.defensa}");
      print("- Ataque Especial: ${pokemon.ataqueEspecial}");
      print("- Defensa Especial: ${pokemon.defensaEspecial}");
      print("- Velocidad: ${pokemon.velocidad}");
      print("\nHabilidades: ${pokemon.habilidades.join(", ")}");

      print("\n¿Quieres guardar este Pokémon en tu base de datos? (s/n)");
      String respuesta = stdin.readLineSync()?.toLowerCase() ?? "n";

      if (respuesta == "s") {
        await guardarPokemonEnBD(pokemon, conn);
      }
    } catch (e) {
      print("Error al mostrar detalles del Pokémon: $e");
    }
  }

  static Future<void> guardarPokemonEnBD(
      Pokemon pokemon, MySqlConnection conn) async {
    try {
      await conn.query(
        'INSERT INTO pokemon (nombre) VALUES (?) ON DUPLICATE KEY UPDATE nombre=nombre',
        [pokemon.nombre],
      );
      print("${pokemon.nombre} guardado en tu base de datos!");
    } catch (e) {
      print("Error al guardar el Pokémon: $e");
    }
  }

  static Future<bool> iniciarSesion(MySqlConnection conn) async {
    try {
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
        print("Inicio de sesión exitoso.");
        return true; // Inicio de sesión exitoso
      } else {
        print("Usuario o contraseña incorrectos.");
        return false; // Usuario o contraseña incorrectos
      }
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return false;
    }
  }
}

void main() async {
  await Menu.menuInicio();
}
/*
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'info.dart';

class Menu {
  static menuInicio() async {
    int opcion;
    do {
      print("\n¿Bienvenido, quieres Registrarte o Iniciar sesión?");
      stdout.writeln("1 - Registrarse | 2 - Iniciar sesión | 3 - Salir");
      String respuesta = stdin.readLineSync() ?? "ERROR";
      opcion = int.tryParse(respuesta) ?? 0;

      switch (opcion) {
        case 1:
          await registrarUsuario;
          break;

        case 2:
          await iniciarSesion;
          await menuSecond;
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

  static Future registrarUsuario(MySqlConnection conn) async {
    await conn.query('USE proyectodart;');
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

  static menuSecond(MySqlConnection conn) async {
    await conn.query('USE proyectodart;');
    {
      int? opcion;
      do {
        print("\n¿Qué quieres hacer?");
        stdout.writeln(
            "1 - Acceder a la Pokedex | 2 - EspacioEnBlanco | 3 - Salir");
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
      } while (opcion != 3);
    }
  }

  static iniciarSesion(MySqlConnection conn) async {
    await conn.query('USE proyectodart;');
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
    }
  }
}
*/