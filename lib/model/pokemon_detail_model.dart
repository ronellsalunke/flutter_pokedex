import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_detail_model.freezed.dart';
part 'pokemon_detail_model.g.dart';

@freezed
abstract class PokemonDetail with _$PokemonDetail {
  const factory PokemonDetail({
    int? height,
    int? id,
    String? name,
    Species? species,
    Sprites? sprites,
    required List<Type> types,
    int? weight,
    required List<Stat> stats,
    @JsonKey(name: "base_experience") int? baseExperience,
    required List<Ability> abilities,
  }) = _PokemonDetail;

  factory PokemonDetail.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailFromJson(json);
}

@freezed
abstract class Species with _$Species {
  const factory Species({
    String? name,
    String? url,
  }) = _Species;

  factory Species.fromJson(Map<String, dynamic> json) =>
      _$SpeciesFromJson(json);
}

@freezed
abstract class Sprites with _$Sprites {
  const factory Sprites({
    @JsonKey(name: "front_default") String? frontDefault,
  }) = _Sprites;

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);
}

@freezed
abstract class Type with _$Type {
  const factory Type({
    int? slot,
    Species? type,
  }) = _Type;

  factory Type.fromJson(Map<String, dynamic> json) =>
      _$TypeFromJson(json);
}

@freezed
abstract class Ability with _$Ability {
  const factory Ability({
    Species? ability,
    @JsonKey(name: "is_hidden") required bool isHidden,
    int? slot,
  }) = _Ability;

  factory Ability.fromJson(Map<String, dynamic> json) =>
      _$AbilityFromJson(json);
}

@freezed
abstract class Stat with _$Stat {
  const factory Stat({
    @JsonKey(name: "base_stat") required int baseStat,
    required int effort,
    required Species stat,
  }) = _Stat;

  factory Stat.fromJson(Map<String, dynamic> json) =>
      _$StatFromJson(json);
}
