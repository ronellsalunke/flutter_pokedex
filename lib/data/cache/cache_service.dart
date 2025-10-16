import 'dart:convert';
import 'package:hive_ce/hive.dart';

class CacheService {
  static const String pokemonListBox = 'pokemon_list';
  static const String pokemonDetailBox = 'pokemon_detail';
  static const Duration cacheDuration = Duration(days: 30);

  late Box<String> _pokemonListBox;
  late Box<String> _pokemonDetailBox;

  Future<void> init() async {
    _pokemonListBox = await Hive.openBox<String>(pokemonListBox);
    _pokemonDetailBox = await Hive.openBox<String>(pokemonDetailBox);
  }

  Future<void> close() async {
    await _pokemonListBox.close();
    await _pokemonDetailBox.close();
  }

  // Cache key for pokemon list with offset and limit
  String _getListKey(int offset, int limit) => 'list_${offset}_${limit}';

  // Cache key for pokemon detail
  String _getDetailKey(int id) => 'detail_$id';

  Future<Map<String, dynamic>?> getPokemonList(int offset, int limit) async {
    final key = _getListKey(offset, limit);
    final cached = _pokemonListBox.get(key);
    if (cached != null) {
      final data = jsonDecode(cached);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
      if (DateTime.now().difference(timestamp) < cacheDuration) {
        return data['data'];
      } else {
        // Cache is stale, remove it
        await _pokemonListBox.delete(key);
      }
    }
    return null;
  }

  Future<void> setPokemonList(
    int offset,
    int limit,
    Map<String, dynamic> data,
  ) async {
    final key = _getListKey(offset, limit);
    final cacheData = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    };
    await _pokemonListBox.put(key, jsonEncode(cacheData));
  }

  Future<Map<String, dynamic>?> getPokemonDetail(int id) async {
    final key = _getDetailKey(id);
    final cached = _pokemonDetailBox.get(key);
    if (cached != null) {
      final data = jsonDecode(cached);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
      if (DateTime.now().difference(timestamp) < cacheDuration) {
        return data['data'];
      } else {
        // Cache is stale, remove it
        await _pokemonDetailBox.delete(key);
      }
    }
    return null;
  }

  Future<void> setPokemonDetail(int id, Map<String, dynamic> data) async {
    final key = _getDetailKey(id);
    final cacheData = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    };
    await _pokemonDetailBox.put(key, jsonEncode(cacheData));
  }

  Future<void> clearAllCache() async {
    await _pokemonListBox.clear();
    await _pokemonDetailBox.clear();
  }
}
