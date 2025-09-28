import 'package:flutter/material.dart';
import 'package:flutter_dex/data/response/api_response.dart';
import 'package:flutter_dex/model/pokemon_model.dart';
import 'package:flutter_dex/model/pokemon_detail_model.dart';
import 'package:flutter_dex/repository/app_repository.dart';

class HomeViewModel with ChangeNotifier {
  final _pokemonRepo = AppRepository();

  ApiResponse<PokemonModel> pokemonList = ApiResponse.loading();
  List<Results> allPokemonResults = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentOffset = 0;
  static const int pageSize = 20;

  setPokemonList(ApiResponse<PokemonModel> response) {
    pokemonList = response;
    notifyListeners();
  }

  Future<void> fetchPokemonModelApi() async {
    setPokemonList(ApiResponse.loading());
    allPokemonResults.clear();
    currentOffset = 0;
    hasMoreData = true;

    _pokemonRepo
        .fetchPokemonList(offset: currentOffset, limit: pageSize)
        .then((value) {
          allPokemonResults.addAll(value.results ?? []);
          hasMoreData = value.next != null;
          currentOffset += pageSize;

          final updatedModel = PokemonModel(
            count: value.count,
            next: value.next,
            previous: value.previous,
            results: allPokemonResults,
          );
          setPokemonList(ApiResponse.completed(updatedModel));
        })
        .onError((error, stackTrace) {
          setPokemonList(ApiResponse.error(error.toString()));
        });
  }

  Future<void> loadMorePokemon() async {
    if (isLoadingMore || !hasMoreData) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      final value = await _pokemonRepo.fetchPokemonList(
        offset: currentOffset,
        limit: pageSize,
      );
      allPokemonResults.addAll(value.results ?? []);
      hasMoreData = value.next != null;
      currentOffset += pageSize;

      final updatedModel = PokemonModel(
        count: value.count,
        next: value.next,
        previous: value.previous,
        results: allPokemonResults,
      );
      setPokemonList(ApiResponse.completed(updatedModel));
    } catch (error) {
      // maybe show snackbar or some other error handling
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<PokemonDetail> fetchPokemonDetailById(int id) async {
    return await _pokemonRepo.fetchPokemonDetail(id);
  }
}
