import 'package:flutter/material.dart';
import 'package:flutter_dex/data/cache/cache_service.dart';
import 'package:flutter_dex/data/response/status.dart';
import 'package:flutter_dex/res/assets.dart';
import 'package:flutter_dex/view/settings_view.dart';
import 'package:flutter_dex/view/widgets/pokemon_list.dart';
import 'package:flutter_dex/viewmodel/home_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:material_loading_indicator/loading_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();
    homeViewModel = HomeViewModel(
      Provider.of<CacheService>(context, listen: false),
    );
    homeViewModel.fetchPokemonModelApi();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => homeViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SvgPicture.asset(
                Assets.pokemonIcon,
                fit: BoxFit.cover,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(width: 8),
              Text('FlutterDex', style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsView()),
                );
              },
            ),
          ],
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, value, _) {
            switch (value.pokemonList.status) {
              case Status.LOADING:
                return Center(child: LoadingIndicator());
              case Status.ERROR:
                // if (value.pokemonList.message?.contains(
                //       "No Internet Connection",
                //     ) ??
                //     false) {
                //   return NoInternetView(onRefresh: value.fetchPokemonModelApi);
                // }
                return Center(
                  child: Text(value.pokemonList.message ?? "Unknown error"),
                );
              case Status.COMPLETED:
                return PokemonList(
                  pokemonModel: value.pokemonList.data!,
                  onLoadMore: value.loadMorePokemon,
                  isLoadingMore: value.isLoadingMore,
                );

              case null:
                return const Center(child: Text('Whoops!'));
            }
          },
        ),
      ),
    );
  }
}
