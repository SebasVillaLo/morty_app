import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../delegate/search_episode_delegate.dart';
import '../views.dart';

class EpisodeView extends ConsumerStatefulWidget {
  const EpisodeView({super.key, this.idsEpisodes, this.nameCharacter})
      : assert(idsEpisodes == null || nameCharacter != null,
            'If idsEpisodes is not null, nameCharacter is required');

  final List<int>? idsEpisodes;
  final String? nameCharacter;

  @override
  ConsumerState<EpisodeView> createState() => _EpisodeViewState();
}

class _EpisodeViewState extends ConsumerState<EpisodeView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.idsEpisodes == null) {
      ref.read(episodeProvider.notifier).loadNextPage();

      scrollController.addListener(() {
        if ((scrollController.position.pixels + 300) >=
            scrollController.position.maxScrollExtent) {
          ref.read(episodeProvider.notifier).loadNextPage();
        }
      });
    } else {
      ref
          .read(episodePerCharactersProvider.notifier)
          .loadEpisodesPerCharacters(widget.idsEpisodes!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final episodes = widget.idsEpisodes == null
        ? ref.watch(episodeProvider)
        : ref.watch(episodePerCharactersProvider);
    return ScaffoldWithAppBar(
      title: widget.idsEpisodes != null
          ? 'Episodes by ${widget.nameCharacter}'
          : 'Episodes',
      backButton: widget.idsEpisodes != null,
      onPressedSearch: () => showSearch(
        context: context,
        delegate: SearchEpisodeDelegate(
          searchEpisodeByName:
              ref.read(episodeProvider.notifier).searchCharacterByName,
        ),
      ),
      child: episodes.isNotEmpty
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
                      itemCount: episodes.length,
                      itemBuilder: (context, index) {
                        return FadeInUp(
                          child: _EpisodeCard(
                            episode: episodes[index],
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

class _EpisodeCard extends StatelessWidget {
  const _EpisodeCard({required this.episode});

  final EpisodeModel episode;

  @override
  Widget build(BuildContext context) {
    return CardView(
      title: episode.name,
      subtitle: episode.episode,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EpisodeDetails(
            episode: episode,
          ),
        ),
      ),
    );
  }
}
