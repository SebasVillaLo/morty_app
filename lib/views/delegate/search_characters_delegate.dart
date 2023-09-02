import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../views.dart';

typedef SearchCharacterCallback = Future<List<CharactersModel>> Function(
    String query);

typedef CharactersStream = StreamController<List<CharactersModel>>;

class SearchCharacterDelegate extends SearchDelegate<CharactersModel?> {
  SearchCharacterDelegate({required this.searchCharacterByName})
      : super(searchFieldLabel: 'Search characters');

  SearchCharacterCallback searchCharacterByName;

  List<CharactersModel> initialData = [];

  CharactersStream debounceCharacters = StreamController.broadcast();

  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  void clearStreams() {
    debounceCharacters.close();
  }

  void _onQueryChanged(String query) {
    if (query.isEmpty) return;
    if (query.isNotEmpty) isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final characters = await searchCharacterByName(query);

      initialData.addAll(characters);
      debounceCharacters.add(characters);

      isLoadingStream.add(false);
    });
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder<List<CharactersModel>>(
      initialData: initialData,
      stream: debounceCharacters.stream,
      builder: (context, snapshot) {
        final characters = snapshot.data ?? [];

        if (characters.isEmpty) {
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
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return CharactersDetails(
                    character: character,
                  );
                }));
              },
              child: FadeIn(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: CardView(
                    title: character.name,
                    image: character.image,
                    subtitle: character.status,
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
