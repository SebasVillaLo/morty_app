import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../characters/characters_api_impl.dart';

final searchedCharactersProvider =
    StateNotifierProvider<SearchCharacterNotifier, List<CharactersModel>>(
        (ref) {
  return SearchCharacterNotifier(ref: ref);
});

typedef SearchCharacterCallback = Future<List<CharactersModel>> Function(
    String query);

class SearchCharacterNotifier extends StateNotifier<List<CharactersModel>> {
  SearchCharacterNotifier({required this.ref}) : super([]);

  final Ref ref;

  Future<List<CharactersModel>> searchCharacterByQuery(String query) async {
    final List<CharactersModel> characters =
        await ref.read(charactersApiProvider).getCharactersByName(query);
    state = characters;
    return characters;
  }
}
