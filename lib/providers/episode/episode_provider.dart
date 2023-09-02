import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../services/morty_api.dart';
import 'episode_api_impl.dart';

final episodeProvider =
    StateNotifierProvider<EpisodeNotifier, List<EpisodeModel>>((ref) {
  final api = ref.read(episodeApiProvider);
  return EpisodeNotifier(api);
});
final episodePerCharactersProvider =
    StateNotifierProvider.autoDispose<EpisodeNotifier, List<EpisodeModel>>(
        (ref) {
  final api = ref.read(episodeApiProvider);
  return EpisodeNotifier(api);
});

class EpisodeNotifier extends StateNotifier<List<EpisodeModel>> {
  EpisodeNotifier(this.api) : super([]);

  final EpisodeApi api;

  int _currentPage = 0;
  bool _isLoading = false;

  Future<void> loadNextPage() async {
    if (_isLoading) return;
    _isLoading = true;

    _currentPage++;
    final episodes = await api.getEpisodes(page: _currentPage);
    state = [...state, ...episodes];
    _isLoading = false;
  }

  Future<void> loadEpisodesPerCharacters(List<int> ids) async {
    final episodes = await api.getEpisodesPerCharacters(ids);
    state = episodes;
  }

  Future<List<EpisodeModel>> searchCharacterByName(String query) async {
    final episodes = await api.getEpisodesByName(query);
    return episodes;
  }
}
