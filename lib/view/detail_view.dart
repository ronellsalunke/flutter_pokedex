import 'package:flutter/material.dart';
import 'package:flutter_dex/model/pokemon_detail_model.dart';
import 'package:flutter_dex/utils/extensions.dart';
import 'package:flutter_dex/view/widgets/stat_bar.dart';

class PokemonDetailView extends StatelessWidget {
  final PokemonDetail pokemon;

  const PokemonDetailView({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '#${pokemon.id ?? '-'}  ${pokemon.name?.toTitleCase ?? 'Details'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.error, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),
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
                              labelStyle: const TextStyle(color: Colors.white),
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card.outlined(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        style: BorderStyle.solid,
                        width: 1,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.straighten_outlined),
                          const SizedBox(height: 16),
                          Text(
                            '${pokemon.height?.toMetersFromDm ?? 0} m',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Card.outlined(
                    surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        style: BorderStyle.solid,
                        width: 1,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.monitor_weight_outlined),
                          const SizedBox(height: 16),
                          Text(
                            '${pokemon.weight?.toKgFromHg ?? 0} kg',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // stats
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...pokemon.stats.map(
                      (stat) => StatBar(
                        stat: stat,
                        color: statValueColor(stat.baseStat),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${pokemon.stats.fold(0, (sum, stat) => sum + stat.baseStat)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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

Color statValueColor(int value) {
  double t = value / 255.0;
  if (t < 0.25) {
    return Color.lerp(Colors.red, Colors.orange, t * 4)!;
  } else if (t < 0.5) {
    return Color.lerp(Colors.orange, Colors.yellow, (t - 0.25) * 4)!;
  } else if (t < 0.75) {
    return Color.lerp(Colors.yellow, Colors.green, (t - 0.5) * 4)!;
  } else {
    return Colors.green;
  }
}
