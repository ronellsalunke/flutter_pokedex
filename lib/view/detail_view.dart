import 'package:flutter/material.dart';

import 'package:flutter_dex/model/pokemon_detail_model.dart';
import 'package:flutter_dex/utils/extensions.dart';

class PokemonDetailView extends StatelessWidget {
  final PokemonDetail pokemon;

  const PokemonDetailView({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name?.toTitleCase ?? 'Details'),
        centerTitle: true,
      ),
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
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.error, size: 80),
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
              children: pokemon.types
                  .map((t) => Chip(
                label: Text(t.type?.name?.toTitleCase ?? ''),
                backgroundColor: _typeColor(t.type?.name),
                labelStyle: const TextStyle(color: Colors.white),
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            /// Attributes
            _AttributeRow(label: 'Height', value: '${pokemon.height ?? 0} dm'),
            _AttributeRow(label: 'Weight', value: '${pokemon.weight ?? 0} hg'),
            _AttributeRow(
                label: 'Species',
                value: pokemon.species?.name?.toTitleCase ?? 'Unknown'),
          ],
        ),
      ),
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
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
