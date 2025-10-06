import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dex/model/pokemon_model.dart';
import 'package:flutter_dex/utils/extensions.dart';
import 'package:flutter_dex/view/detail_view.dart';
import 'package:flutter_dex/viewmodel/home_viewmodel.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
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

  void _navigateToPokemonDetail(BuildContext context, int pokemonId) {
    final homeViewModel = context.read<HomeViewModel>();
    final cachedDetail = homeViewModel.getCachedDetail(pokemonId);
    if (cachedDetail != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PokemonDetailView(pokemonDetail: cachedDetail)),
      );
    } else {
      // Show loading and fetch
      showDialog(
        context: context,
        builder: (_) => Center(child: LoadingIndicator.contained()),
        barrierDismissible: false,
      );
      homeViewModel.getSpriteUrl(pokemonId).then((_) {
        if (!context.mounted) return;
        Navigator.pop(context);
        final detail = homeViewModel.getCachedDetail(pokemonId);
        if (detail != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PokemonDetailView(pokemonDetail: detail)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PokemonDetailView(pokemonId: pokemonId)),
          );
        }
      }).catchError((error) {
        if (!context.mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load details: $error")),
        );
      });
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

               FilledButton.tonal(
                 onPressed: () {
                   final total = widget.pokemonModel.count ?? 0;
                   if (total > 0) {
                     final randomId = Random().nextInt(total) + 1;
                     _navigateToPokemonDetail(context, randomId);
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
                  return Card.outlined(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        style: BorderStyle.solid,
                        width: 1,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: LoadingIndicator(),
                      ),
                    ),
                  );
                }

                final pokemon = results[index];
                // Extract Pokemon ID from URL for image
                final pokemonId = _extractPokemonId(pokemon.url);
                return Card.outlined(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      style: BorderStyle.solid,
                      width: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                     onTap: () => _navigateToPokemonDetail(context, pokemonId),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Hero(
                            tag: pokemon.name ?? '',
                            // Add this flightShuttleBuilder to use a consistent image during animation
                            flightShuttleBuilder: (
                                BuildContext flightContext,
                                Animation<double> animation,
                                HeroFlightDirection flightDirection,
                                BuildContext fromHeroContext,
                                BuildContext toHeroContext,
                                ) {
                              final homeViewModel = context.read<HomeViewModel>();
                              final spriteUrl = homeViewModel.spriteUrls[pokemonId];

                              if (spriteUrl != null && spriteUrl.isNotEmpty) {
                                return CachedNetworkImage(
                                  imageUrl: spriteUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                  fadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  errorWidget: (context, url, error) => SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: const Icon(Icons.image_not_supported),
                                  ),
                                );
                              }
                              return SizedBox(
                                width: 80,
                                height: 80,
                                child: LoadingIndicator(),
                              );
                            },
                            child: Builder(
                              builder: (context) {
                                final homeViewModel = context.read<HomeViewModel>();
                                final spriteUrl = homeViewModel.spriteUrls[pokemonId];
                                if (spriteUrl != null && spriteUrl.isNotEmpty) {
                                  return CachedNetworkImage(
                                    imageUrl: spriteUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    fadeInDuration: Duration.zero,
                                    fadeOutDuration: Duration.zero, // Add this
                                    // Add placeholder to prevent loading indicator flash
                                    placeholder: (context, url) => SizedBox(
                                      width: 80,
                                      height: 80,
                                    ),
                                    errorWidget: (context, url, error) => SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                                  );
                                } else {
                                  homeViewModel.getSpriteUrl(pokemonId);
                                  return SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: LoadingIndicator(),
                                  );
                                }
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
