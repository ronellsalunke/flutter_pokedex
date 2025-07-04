import 'package:flutter/material.dart';
import 'package:flutter_dex/model/pokemon_model.dart';
import 'package:flutter_dex/utils/extensions.dart';
import 'package:flutter_dex/view/detail_view.dart';
import 'package:flutter_dex/viewmodel/detail_viewmodel.dart';
// or your API service

class PokemonList extends StatelessWidget {
  final List<Results> results;

  const PokemonList({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pokemon = results[index];

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Hero(
              tag: pokemon.name ?? '',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png",
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              pokemon.name?.toTitleCase ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),

            // 👇 Navigation
            onTap: () async {
              final detailUrl = pokemon.url;
              if (detailUrl != null) {
                showDialog(
                  context: context,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                try {
                  final detail = await PokemonService().fetchPokemonDetail(detailUrl);
                  Navigator.pop(context); // close loading
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PokemonDetailView(pokemon: detail),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to load details: $e")),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}
