import 'package:flutter/material.dart';
import 'package:flutter_dex/data/response/api_response.dart';
import 'package:flutter_dex/model/pokemon_model.dart';
import 'package:flutter_dex/repository/app_repository.dart';

class HomeViewModel with ChangeNotifier {
  final _pokemonRepo = AppRepository();

  ApiResponse<PokemonModel> pokemonList = ApiResponse.loading();

  setPokemonList(ApiResponse<PokemonModel> response) {
    pokemonList = response;
    notifyListeners();
  }

  Future<void> fetchPokemonModelApi () async {
    setPokemonList(ApiResponse.loading());
    _pokemonRepo.fetchPokemonList().then((value){
      setPokemonList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setPokemonList(ApiResponse.error(error.toString()));
    });
  }
}