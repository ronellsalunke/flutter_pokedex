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
  Map<int, String> spriteUrls = {};
  Map<int, PokemonDetail> cachedDetails = {};
  Map<int, Future<String>> spriteFutures = {};

  void setPokemonList(ApiResponse<PokemonModel> response) {
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
        .then((value) async {
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
          await _fetchAllSprites();
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
      setPokemonList(ApiResponse.error(error.toString()));
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<PokemonDetail> fetchPokemonDetailById(int id) async {
    return await _pokemonRepo.fetchPokemonDetail(id);
  }

  Future<String> getSpriteUrl(int id) {
    if (spriteFutures.containsKey(id)) {
      return spriteFutures[id]!;
    }
    final future = _fetchSpriteUrl(id);
    spriteFutures[id] = future;
    return future;
  }

  Future<String> _fetchSpriteUrl(int id) async {
    try {
      final detail = await _pokemonRepo.fetchPokemonDetail(id);
      cachedDetails[id] = detail;
      final url = detail.sprites?.other?.officialArtwork?.frontDefault ?? '';
      spriteUrls[id] = url;
      notifyListeners();
      return url;
    } catch (e) {
      return '';
    }
  }

  int _extractPokemonId(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    if (segments.isNotEmpty) {
      for (int i = segments.length - 1; i >= 0; i--) {
        if (segments[i].isNotEmpty) {
          return int.tryParse(segments[i]) ?? 1;
        }
      }
    }
    return 1;
  }

  Future<void> _fetchAllSprites() async {
    final futures = allPokemonResults.map((p) => getSpriteUrl(_extractPokemonId(p.url!))).toList();
    await Future.wait(futures);
  }

  PokemonDetail? getCachedDetail(int id) => cachedDetails[id];
}
