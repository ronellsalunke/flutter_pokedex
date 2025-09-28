import 'package:flutter/material.dart';

import 'package:flutter_dex/model/pokemon_detail_model.dart';
import 'package:flutter_dex/utils/extensions.dart';

class PokemonDetailView extends StatelessWidget {
  final PokemonDetail pokemon;

  const PokemonDetailView({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final typeNames = pokemon.types.map((t) => t.type?.name).toList();

    return Container(
      decoration: BoxDecoration(gradient: _typeGradient(typeNames)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(pokemon.name?.toTitleCase ?? 'Details'),
          centerTitle: true,
          backgroundColor: _typeColor(typeNames.first),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Image
              Center(
                child: Hero(
                  tag: pokemon.name ?? '',
                  child: Image.network(
                    pokemon.sprites?.frontDefault ??
                        'https://via.placeholder.com/150',
                    height: 160,
                    width: 160,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (_, __, ___) => const Icon(Icons.error, size: 80),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// ID & Name
              Text(
                '#${pokemon.id ?? '-'}  ${pokemon.name?.toTitleCase ?? ''}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              /// Types
              Wrap(
                spacing: 8,
                children:
                    pokemon.types
                        .map(
                          (t) => Chip(
                            label: Text(t.type?.name?.toTitleCase ?? ''),
                            backgroundColor: _typeColor(t.type?.name),
                            labelStyle: const TextStyle(color: Colors.white),
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children:
                        pokemon.abilities
                            .map(
                              (a) => Chip(
                                label: Text(a.ability?.name?.toTitleCase ?? ''),
                                backgroundColor:
                                    a.isHidden
                                        ? Colors.deepPurpleAccent
                                        : _typeColor(a.ability?.name),
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                side: BorderSide.none,
                                avatar:
                                    a.isHidden
                                        ? Icon(Icons.star, color: Colors.white)
                                        : null,
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                // color: Colors.white.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _AttributeRow(
                        label: 'Height',
                        value: '${pokemon.height?.toMetersFromDm ?? 0} m',
                      ),
                      _AttributeRow(
                        label: 'Weight',
                        value: '${pokemon.weight?.toKgFromHg ?? 0} kg',
                      ),
                      _AttributeRow(
                        label: 'Species',
                        value: pokemon.species?.name?.toTitleCase ?? 'Unknown',
                      ),
                      _AttributeRow(
                        label: "Base Experience",
                        value: "${pokemon.baseExperience ?? 0}",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _typeGradient(List<String?> types) {
    if (types.isEmpty) {
      return const LinearGradient(colors: [Colors.grey, Colors.black26]);
    }

    if (types.length == 1) {
      final color = _typeColor(types.first);
      return LinearGradient(
        colors: [color, color.withValues(alpha: 0.8)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    final colors = types.map((t) => _typeColor(t)).toList();
    return LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  Color _typeColor(String? typeName) {
    switch (typeName?.toLowerCase()) {
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amber;
      case 'psychic':
        return Colors.purple;
      case 'rock':
        return Colors.brown;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black87;
      case 'fairy':
        return Colors.pinkAccent;
      case 'poison':
        return Colors.deepPurple;
      case 'flying':
        return Colors.lightBlueAccent;
      case 'bug':
        return Colors.lightGreenAccent;
      case 'fighting':
        return Colors.orange;
      case 'ground':
        return Colors.brown;
      case 'ghost':
        return Colors.indigoAccent;
      default:
        return Colors.grey;
    }
  }
}

class _AttributeRow extends StatelessWidget {
  final String label;
  final String value;

  const _AttributeRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
