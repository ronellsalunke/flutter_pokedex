import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_model.freezed.dart';
part 'pokemon_model.g.dart';

@freezed
abstract class PokemonModel with _$PokemonModel {
  const factory PokemonModel({
    int? count,
    String? next,
    String? previous,
    List<Results>? results,
  }) = _PokemonModel;

  factory PokemonModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonModelFromJson(json);
}

@freezed
abstract class Results with _$Results {
  const factory Results({
    String? name,
    String? url,
  }) = _Results;

  factory Results.fromJson(Map<String, dynamic> json) =>
      _$ResultsFromJson(json);
}
