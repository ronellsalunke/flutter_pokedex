import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dex/model/pokemon_model.dart';
import 'package:flutter_dex/res/app_url.dart';
import 'package:flutter_dex/utils/extensions.dart';
import 'package:flutter_dex/view/detail_view.dart';
import 'package:flutter_dex/viewmodel/detail_viewmodel.dart';
import 'package:flutter_dex/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class PokemonList extends StatefulWidget {
  final PokemonModel pokemonModel;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  const PokemonList({
    super.key,
    required this.pokemonModel,
    this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 100) {
      widget.onLoadMore?.call();
    }
  }

  int _extractPokemonId(String? url) {
    if (url == null) return 1;
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    if (segments.isNotEmpty) {
      for (int i = segments.length - 1; i >= 0; i--) {
        if (segments[i].isNotEmpty) {
          return int.tryParse(segments[i]) ?? 1;
        }
      }
    }
    return 1;
  }

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
      Navigator.pop(context);
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
    final results = widget.pokemonModel.results ?? [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Pokémon: ${widget.pokemonModel.count!}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  final total = widget.pokemonModel.count ?? 0;
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
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollUpdateNotification ||
                  scrollInfo is ScrollEndNotification) {
                final position = scrollInfo.metrics;
                if (position.pixels >= position.maxScrollExtent - 50) {
                  widget.onLoadMore?.call();
                }
              }
              return false;
            },
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: results.length + (widget.isLoadingMore ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                // Show loading indicator at the end
                if (index == results.length) {
                  return const Card(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                final pokemon = results[index];
                // Extract Pokemon ID from URL for image
                final pokemonId = _extractPokemonId(pokemon.url);

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
                              "${AppUrl.thumbnailUrl}/$pokemonId.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
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
        ),
      ],
    );
  }
}
