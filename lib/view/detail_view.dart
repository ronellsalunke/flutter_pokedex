import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dex/data/cache/cache_service.dart';
import 'package:flutter_dex/data/response/api_response.dart';
import 'package:flutter_dex/data/response/status.dart';
import 'package:flutter_dex/model/pokemon_detail_model.dart';
import 'package:flutter_dex/utils/extensions.dart';
import 'package:flutter_dex/view/widgets/stat_bar.dart';
import 'package:flutter_dex/viewmodel/detail_viewmodel.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../res/colors.dart';

class PokemonDetailView extends StatefulWidget {
  final PokemonDetail? pokemonDetail;
  final int? pokemonId;

  const PokemonDetailView({super.key, this.pokemonDetail, this.pokemonId})
    : assert(pokemonDetail != null || pokemonId != null);

  @override
  State<PokemonDetailView> createState() => _PokemonDetailViewState();
}

class _PokemonDetailViewState extends State<PokemonDetailView> {
  late final DetailViewModel detailViewModel;

  @override
  void initState() {
    super.initState();
    detailViewModel = DetailViewModel(
      Provider.of<CacheService>(context, listen: false),
    );
    if (widget.pokemonDetail != null) {
      detailViewModel.setPokemonDetail(
        ApiResponse.completed(widget.pokemonDetail!),
      );
    } else {
      detailViewModel.fetchPokemonDetail(widget.pokemonId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailViewModel>(
      create: (_) => detailViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<DetailViewModel>(
            builder: (context, value, _) {
              switch (value.pokemonDetail.status) {
                case Status.COMPLETED:
                  final pokemon = value.pokemonDetail.data!;
                  return Text(
                    '#${pokemon.id ?? '-'}  ${pokemon.name?.toTitleCase ?? 'Details'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                default:
                  return const Text('Loading...');
              }
            },
          ),
          centerTitle: true,
        ),
        body: Consumer<DetailViewModel>(
          builder: (context, value, _) {
            switch (value.pokemonDetail.status) {
              case Status.LOADING:
                return Center(child: LoadingIndicator());
              case Status.ERROR:
                return Center(
                  child: Text(value.pokemonDetail.message ?? "Unknown error"),
                );
              case Status.COMPLETED:
                final pokemon = value.pokemonDetail.data!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      /// Image
                      Center(
                        child: Hero(
                          tag: pokemon.name ?? '',
                          // Add this to ensure smooth animation back
                          flightShuttleBuilder: (
                            BuildContext flightContext,
                            Animation<double> animation,
                            HeroFlightDirection flightDirection,
                            BuildContext fromHeroContext,
                            BuildContext toHeroContext,
                          ) {
                            return CachedNetworkImage(
                              imageUrl:
                                  pokemon
                                      .sprites
                                      ?.other
                                      ?.officialArtwork
                                      ?.frontDefault ??
                                  'https://via.placeholder.com/150',
                              height: 160,
                              width: 160,
                              fit: BoxFit.contain,
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              errorWidget:
                                  (context, url, error) =>
                                      const Icon(Icons.error, size: 80),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl:
                                pokemon
                                    .sprites
                                    ?.other
                                    ?.officialArtwork
                                    ?.frontDefault ??
                                'https://via.placeholder.com/150',
                            height: 160,
                            width: 160,
                            fit: BoxFit.contain,
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            // Add this
                            placeholder:
                                (context, url) =>
                                    SizedBox(height: 160, width: 160),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error, size: 80),
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
                                    label: Text(
                                      t.type?.name?.toTitleCase ?? '',
                                    ),
                                    backgroundColor: _typeColor(t.type?.name),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
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
                                        label: Text(
                                          a.ability?.name?.toTitleCase ?? '',
                                        ),
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
                                                ? Icon(
                                                  Icons.star,
                                                  color: Colors.white,
                                                )
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
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
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
                              surfaceTintColor:
                                  Theme.of(context).colorScheme.surfaceTint,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                );
              case null:
                return const Center(child: Text('Whoops!'));
            }
          },
        ),
      ),
    );
  }

  Color _typeColor(String? typeName) {
    switch (typeName?.toLowerCase()) {
      case 'fire':
        return AppColors.fire;
      case 'water':
        return AppColors.water;
      case 'grass':
        return AppColors.grass;
      case 'electric':
        return AppColors.electric;
      case 'psychic':
        return AppColors.psychic;
      case 'rock':
        return AppColors.rock;
      case 'ice':
        return AppColors.ice;
      case 'dragon':
        return AppColors.dragon;
      case 'dark':
        return AppColors.dark;
      case 'fairy':
        return AppColors.fairy;
      case 'poison':
        return AppColors.poison;
      case 'flying':
        return AppColors.flying;
      case 'bug':
        return AppColors.bug;
      case 'fighting':
        return AppColors.fighting;
      case 'ground':
        return AppColors.ground;
      case 'ghost':
        return AppColors.ghost;
      case 'steel':
        return AppColors.steel;
      default:
        return AppColors.normal;
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
