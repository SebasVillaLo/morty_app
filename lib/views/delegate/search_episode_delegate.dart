import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../views.dart';

typedef SearchEpisodeCallback = Future<List<EpisodeModel>> Function(
    String query);

typedef EpisodesStream = StreamController<List<EpisodeModel>>;

class SearchEpisodeDelegate extends SearchDelegate<EpisodeModel?> {
  SearchEpisodeDelegate({required this.searchEpisodeByName})
      : super(searchFieldLabel: 'Search episodes');

  SearchEpisodeCallback searchEpisodeByName;

  List<EpisodeModel> initialData = [];

  EpisodesStream debounceEpisodes = StreamController.broadcast();

  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  void clearStreams() {
    debounceEpisodes.close();
  }

  void _onQueryChanged(String query) {
    if (query.isEmpty) return;
    if (query.isNotEmpty) isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final episodes = await searchEpisodeByName(query);

      initialData.addAll(episodes);
      debounceEpisodes.add(episodes);

      isLoadingStream.add(false);
    });
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder<List<EpisodeModel>>(
      initialData: initialData,
      stream: debounceEpisodes.stream,
      builder: (context, snapshot) {
        final episodes = snapshot.data ?? [];

        if (episodes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.search_off_rounded,
                  size: 100,
                ),
                SizedBox(height: 10),
                Text(
                  'No results found',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final episode = episodes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return EpisodeDetails(
                    episode: episode,
                  );
                }));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: FadeIn(
                  child: CardView(
                    title: episode.name,
                    subtitle: episode.episode,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: isLoadingStream.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              infinite: true,
              spins: 10,
              child: const Icon(Icons.refresh_rounded),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () {
                query = '';
              },
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsAndSuggestions();
  }
}
