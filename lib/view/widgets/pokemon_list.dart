import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dex/model/pokemon_model.dart';
import 'package:flutter_dex/utils/extensions.dart';
import 'package:flutter_dex/view/detail_view.dart';
import 'package:flutter_dex/viewmodel/detail_viewmodel.dart';
import 'package:flutter_dex/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class PokemonList extends StatelessWidget {
  final PokemonModel pokemonModel;

  const PokemonList({super.key, required this.pokemonModel});

  Future<void> _openPokemonDetail(
    BuildContext context,
    String url,
    String tag,
  ) async {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final detail = await PokemonService().fetchPokemonDetail(url);
      Navigator.pop(context); // close loader
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PokemonDetailView(pokemon: detail)),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load details: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = pokemonModel.results ?? [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Pokémon: ${pokemonModel.count!}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final total = pokemonModel.count ?? 0;
                  if (total > 0) {
                    final randomId = Random().nextInt(total) + 1;
                    showDialog(
                      context: context,
                      builder:
                          (_) =>
                              const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );

                    try {
                      final detail = await context
                          .read<HomeViewModel>()
                          .fetchPokemonDetailById(randomId);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PokemonDetailView(pokemon: detail),
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to load random Pokémon: $e"),
                        ),
                      );
                    }
                  }
                },
                child: const Text("Random"),
              ),
            ],
          ),
        ),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final pokemon = results[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    final detailUrl = pokemon.url;
                    if (detailUrl != null) {
                      _openPokemonDetail(
                        context,
                        detailUrl,
                        pokemon.name ?? '',
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag: pokemon.name ?? '',
                          child: Image.network(
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        pokemon.name?.toTitleCase ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
