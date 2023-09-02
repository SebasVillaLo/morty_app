import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../providers/characters/characters_provider.dart';
import '../../widgets/widgets.dart';
import '../delegate/search_characters_delegate.dart';
import 'characters_details.dart';

class CharacterView extends ConsumerStatefulWidget {
  const CharacterView({super.key});

  @override
  ConsumerState<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends ConsumerState<CharacterView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(charactersProvider.notifier).loadNextPage();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 300) >=
          scrollController.position.maxScrollExtent) {
        ref.read(charactersProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final characters = ref.watch(charactersProvider);

    return ScaffoldWithAppBar(
      title: 'Characters',
      onPressedSearch: () => showSearch(
        context: context,
        delegate: SearchCharacterDelegate(
          searchCharacterByName:
              ref.read(charactersProvider.notifier).searchCharacterByName,
        ),
      ),
      child: characters.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        return FadeIn(
                          child: FadeInUp(
                            child: _CharacterCard(
                              character: characters[index],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )
          : const LoadingCircular(),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  const _CharacterCard({
    required this.character,
  });

  final CharactersModel character;

  @override
  Widget build(BuildContext context) {
    return CardView(
      title: character.name,
      subtitle: character.status,
      image: character.image,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CharactersDetails(
            character: character,
          ),
        ),
      ),
    );
  }
}
