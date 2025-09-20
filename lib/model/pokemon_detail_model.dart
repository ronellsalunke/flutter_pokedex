class PokemonDetail {
  PokemonDetail({
    required this.height,
    required this.id,
    required this.name,
    required this.species,
    required this.sprites,
    required this.types,
    required this.weight,
    required this.baseExperience,
    required this.abilities,
  });

  final int? height;
  final int? id;
  final String? name;
  final Species? species;
  final Sprites? sprites;
  final List<Type> types;
  final int? weight;
  final int? baseExperience;
  final List<Ability> abilities;

  PokemonDetail copyWith({
    int? height,
    int? id,
    String? name,
    Species? species,
    Sprites? sprites,
    List<Type>? types,
    int? weight,
    int? baseExperience,
    List<Ability>? abilities,
  }) {
    return PokemonDetail(
      height: height ?? this.height,
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      sprites: sprites ?? this.sprites,
      types: types ?? this.types,
      weight: weight ?? this.weight,
      baseExperience: baseExperience ?? this.baseExperience,
      abilities: abilities ?? this.abilities,
    );
  }

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      height: json["height"],
      id: json["id"],
      name: json["name"],
      species:
          json["species"] == null ? null : Species.fromJson(json["species"]),
      sprites:
          json["sprites"] == null ? null : Sprites.fromJson(json["sprites"]),
      types:
          json["types"] == null
              ? []
              : List<Type>.from(json["types"]!.map((x) => Type.fromJson(x))),
      weight: json["weight"],
      baseExperience: json["base_experience"],
      abilities:
          json["abilities"] == null
              ? []
              : List<Ability>.from(
                json["abilities"]!.map((x) => Ability.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "height": height,
    "id": id,
    "name": name,
    "species": species?.toJson(),
    "sprites": sprites?.toJson(),
    "types": types.map((x) => x.toJson()).toList(),
    "weight": weight,
    "base_experience": baseExperience,
    "abilities": abilities.map((x) => x.toJson()).toList(),
  };

  @override
  String toString() {
    return "$height, $id, $name , $species, $sprites, $types, $weight, $baseExperience";
  }
}

class Species {
  Species({required this.name, required this.url});

  final String? name;
  final String? url;

  Species copyWith({String? name, String? url}) {
    return Species(name: name ?? this.name, url: url ?? this.url);
  }

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(name: json["name"], url: json["url"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "url": url};

  @override
  String toString() {
    return "$name, $url, ";
  }
}

class Sprites {
  Sprites({required this.frontDefault});

  final String? frontDefault;

  Sprites copyWith({String? frontDefault}) {
    return Sprites(frontDefault: frontDefault ?? this.frontDefault);
  }

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(frontDefault: json["front_default"]);
  }

  Map<String, dynamic> toJson() => {"front_default": frontDefault};

  @override
  String toString() {
    return " $frontDefault ";
  }
}

class Type {
  Type({required this.slot, required this.type});

  final int? slot;
  final Species? type;

  Type copyWith({int? slot, Species? type}) {
    return Type(slot: slot ?? this.slot, type: type ?? this.type);
  }

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      slot: json["slot"],
      type: json["type"] == null ? null : Species.fromJson(json["type"]),
    );
  }

  Map<String, dynamic> toJson() => {"slot": slot, "type": type?.toJson()};

  @override
  String toString() {
    return "$slot, $type, ";
  }
}

class Ability {
  Ability({required this.ability, required this.isHidden, required this.slot});

  final Species? ability;
  final bool isHidden;
  final int? slot;

  Ability copyWith({Species? ability, bool? isHidden, int? slot}) {
    return Ability(
      ability: ability ?? this.ability,
      isHidden: isHidden ?? this.isHidden,
      slot: slot ?? this.slot,
    );
  }

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      ability:
          json["ability"] == null ? null : Species.fromJson(json["ability"]),
      isHidden: json["is_hidden"],
      slot: json["slot"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ability": ability?.toJson(),
    "is_hidden": isHidden,
    "slot": slot,
  };

  @override
  String toString() {
    return "$ability, hidden: $isHidden, slot: $slot";
  }
}