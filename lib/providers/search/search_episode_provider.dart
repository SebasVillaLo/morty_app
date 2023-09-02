import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../episode/episode_api_impl.dart';

final searchedEpisodeProvider =
    StateNotifierProvider<SearchEpisodeNotifier, List<EpisodeModel>>((ref) {
  return SearchEpisodeNotifier(ref: ref);
});

typedef SearchEpisodeCallback = Future<List<EpisodeModel>> Function(
    String query);

class SearchEpisodeNotifier extends StateNotifier<List<EpisodeModel>> {
  SearchEpisodeNotifier({required this.ref}) : super([]);

  final Ref ref;

  Future<List<EpisodeModel>> searchEpisodeByQuery(String query) async {
    final List<EpisodeModel> episodes =
        await ref.read(episodeApiProvider).getEpisodesByName(query);
    state = episodes;
    return episodes;
  }
}
