import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../services/morty_api.dart';
import 'characters_api_impl.dart';

final charactersProvider =
    StateNotifierProvider<CharactersNotifier, List<CharactersModel>>((ref) {
  final api = ref.read(charactersApiProvider);
  return CharactersNotifier(api);
});

final charactersPerEpisodeProvider = StateNotifierProvider.autoDispose<
    CharactersNotifier, List<CharactersModel>>((ref) {
  final api = ref.read(charactersApiProvider);
  return CharactersNotifier(api);
});
final charactersPerLocationProvider = StateNotifierProvider.autoDispose<
    CharactersNotifier, List<CharactersModel>>((ref) {
  final api = ref.read(charactersApiProvider);
  return CharactersNotifier(api);
});

class CharactersNotifier extends StateNotifier<List<CharactersModel>> {
  CharactersNotifier(this.api) : super([]);

  final CharactersApi api;

  int _currentPage = 0;
  bool _isLoading = false;

  Future<void> loadNextPage() async {
    if (_isLoading) return;
    _isLoading = true;

    _currentPage++;
    final characters = await api.getCharacters(page: _currentPage);
    state = [...state, ...characters];
    _isLoading = false;
  }

  Future<void> loadCharactersPerEpisode(List<int> ids) async {
    final characters = await api.getCharacterByIds(ids);
    state = characters;
  }

  Future<List<CharactersModel>> searchCharacterByName(String query) async {
    final characters = await api.getCharactersByName(query);
    return characters;
  }
}
