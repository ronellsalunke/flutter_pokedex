import 'package:flutter/material.dart';
import 'package:flutter_dex/data/response/status.dart';
import 'package:flutter_dex/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    homeViewModel.fetchPokemonModelApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeDex'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<HomeViewModel>(create: (BuildContext context) => homeViewModel, child: Consumer<HomeViewModel>(builder: (context, value, _){
        switch(value.pokemonList.status){
          case Status.LOADING:
            return Center(child: CircularProgressIndicator());
          case Status.ERROR:
            return Center(child: Text(value.pokemonList.message.toString()));
          case Status.COMPLETED:
            return Center(
              child: Text("There are ${value.pokemonList.data?.count.toString()} Pokemon!")
            );
          case null:
            return Center(
              child: Text('Whoops!'),
            );
        }
      }),),
    );
  }
}
