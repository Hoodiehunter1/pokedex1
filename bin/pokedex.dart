import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'info.dart';
import 'menus.dart';
import 'base.dart';

main() {
  BaseDatos.installBBDD();
  Menu.menuInicio();
}

// cd bin dart pokedex.dart
/*
obtenerPokemon(String nombre) async {
  //Este metodo te dice que escribas un pokemon y la api me da la info de él
  Uri url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$nombre');
  var respuesta = await http.get(url);
  try {
    if (respuesta.statusCode == 200) {
      List lista = await listaDeHabilidades(body);
      Pokemon pokemon = Pokemon.fromAPI(body,
          lista); //El constructor from api coje la info de la api y me la convierte en un pokemon
      return pokemon; //me devuelve el pokemon como objeto pokemon
    } else if (respuesta.statusCode == 404) {
      throw ("El pokemon no existe");
    } else {
      throw ("Error al obtener el pokemon");
    }
  } catch (e) {
    stdout.write(e);
  }
}
*/
//Hay una aplicacion llamada Postman que te permite hacer pruebas a apis
//Las habilidades las ignoramos de momento

/*
case 'attack':
ataque= elemento['base_stat'];
break;
*/