import 'package:flutter/material.dart';
import 'package:flutter_dex/data/response/status.dart';
import 'package:flutter_dex/view/settings_view.dart';
import 'package:flutter_dex/view/widgets/no_internet_view.dart';
import 'package:flutter_dex/view/widgets/pokemon_list.dart';
import 'package:flutter_dex/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    homeViewModel.fetchPokemonModelApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => homeViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FlutterDex'),
          centerTitle: true,
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
                return const Center(child: CircularProgressIndicator());
              case Status.ERROR:
                if (value.pokemonList.message?.contains("No Internet Connection") ?? false) {
                  return NoInternetView(onRefresh: value.fetchPokemonModelApi);
                }
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
