import 'package:flutter_dex/data/network/base_api_services.dart';
import 'package:flutter_dex/data/network/network_api_service.dart';
import 'package:flutter_dex/model/pokemon_detail_model.dart';
import 'package:flutter_dex/model/pokemon_model.dart';
import 'package:flutter_dex/res/app_url.dart';

class AppRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<PokemonModel> fetchPokemonList() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.baseUrl);
      return response = PokemonModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<PokemonDetail> fetchPokemonDetail(int id) async {
    try {
      final url = "${AppUrl.baseUrl}/$id";
      dynamic response = await _apiServices.getGetApiResponse(url);
      return PokemonDetail.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
