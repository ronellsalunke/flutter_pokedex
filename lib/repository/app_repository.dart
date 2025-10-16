import 'package:flutter_dex/data/cache/cache_service.dart';
import 'package:flutter_dex/data/network/base_api_services.dart';
import 'package:flutter_dex/data/network/network_api_service.dart';
import 'package:flutter_dex/model/pokemon_detail_model.dart';
import 'package:flutter_dex/model/pokemon_model.dart';
import 'package:flutter_dex/res/app_url.dart';

class AppRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  final CacheService _cacheService;

  AppRepository(this._cacheService);

  Future<PokemonModel> fetchPokemonList({
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      // Try to get from cache first
      final cachedData = await _cacheService.getPokemonList(offset, limit);
      if (cachedData != null) {
        return PokemonModel.fromJson(cachedData);
      }

      // If not in cache or stale, fetch from network
      final url = "${AppUrl.baseUrl}?offset=$offset&limit=$limit";
      dynamic response = await _apiServices.getGetApiResponse(url);
      final pokemonModel = PokemonModel.fromJson(response);

      // Cache the response
      await _cacheService.setPokemonList(offset, limit, response);

      return pokemonModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<PokemonDetail> fetchPokemonDetail(int id) async {
    try {
      // Try to get from cache first
      final cachedData = await _cacheService.getPokemonDetail(id);
      if (cachedData != null) {
        return PokemonDetail.fromJson(cachedData);
      }

      // If not in cache or stale, fetch from network
      final url = "${AppUrl.baseUrl}/$id";
      dynamic response = await _apiServices.getGetApiResponse(url);
      final pokemonDetail = PokemonDetail.fromJson(response);

      // Cache the response
      await _cacheService.setPokemonDetail(id, response);

      return pokemonDetail;
    } catch (e) {
      rethrow;
    }
  }
}
