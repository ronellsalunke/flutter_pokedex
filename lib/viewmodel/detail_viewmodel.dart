import 'package:flutter/material.dart';
import 'package:flutter_dex/data/response/api_response.dart';
import 'package:flutter_dex/model/pokemon_detail_model.dart';
import 'package:flutter_dex/repository/app_repository.dart';

class DetailViewModel with ChangeNotifier {
  final _pokemonRepo = AppRepository();

  ApiResponse<PokemonDetail> pokemonDetail = ApiResponse.loading();

  void setPokemonDetail(ApiResponse<PokemonDetail> response) {
    pokemonDetail = response;
    notifyListeners();
  }

  Future<void> fetchPokemonDetail(int id) async {
    setPokemonDetail(ApiResponse.loading());
    _pokemonRepo
        .fetchPokemonDetail(id)
        .then((value) {
          setPokemonDetail(ApiResponse.completed(value));
        })
        .onError((error, stackTrace) {
          setPokemonDetail(ApiResponse.error(error.toString()));
        });
  }
}
