import 'dart:convert';
import 'package:http/http.dart' as http;
import 'info.dart';

class PokeApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/';

  static Future<Map<String, dynamic>> getPokemonData(String identifier) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/pokemon/$identifier'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Excepción al obtener datos: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getPokemonList(int limit) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Error al obtener lista: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Excepción al obtener lista: $e');
    }
  }

  static Pokemon mapApiDataToPokemon(Map<String, dynamic> apiData) {
    return Pokemon()
      ..nombre = apiData['name']
      ..vida = apiData['stats'][0]['base_stat']
      ..ataque = apiData['stats'][1]['base_stat']
      ..defensa = apiData['stats'][2]['base_stat']
      ..ataqueEspecial = apiData['stats'][3]['base_stat']
      ..defensaEspecial = apiData['stats'][4]['base_stat']
      ..velocidad = apiData['stats'][5]['base_stat']
      ..habilidades = (apiData['abilities'] as List)
          .map((ability) => ability['ability']['name'] as String)
          .toList()
      ..habilidad = apiData['abilities'][0]['ability']['name'];
  }
}
