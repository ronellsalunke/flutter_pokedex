import 'dart:convert';
import 'package:flutter_dex/model/pokemon_detail_model.dart';
import 'package:http/http.dart' as http;

class PokemonService {
  Future<PokemonDetail> fetchPokemonDetail(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return PokemonDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load Pokémon details");
    }
  }
}
