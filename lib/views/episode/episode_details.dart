import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class EpisodeDetails extends ConsumerStatefulWidget {
  const EpisodeDetails({super.key, required this.episode});

  final EpisodeModel episode;

  @override
  ConsumerState<EpisodeDetails> createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends ConsumerState<EpisodeDetails> {
  @override
  void initState() {
    super.initState();
    final ids = getIds(widget.episode.characters);
    ref
        .read(charactersPerEpisodeProvider.notifier)
        .loadCharactersPerEpisode(ids);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final characters = ref.watch(charactersPerEpisodeProvider);
    return ScaffoldWithAppBar(
      title: 'Episode details',
      backButton: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.episode.name,
              style: textStyle.titleLarge!.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 10),
            Text('Details', style: textStyle.titleSmall),
            const SizedBox(height: 10),
            ListDetailsWidget(title: 'Episode:', value: widget.episode.episode),
            const SizedBox(height: 8),
            ListDetailsWidget(title: 'Gender: ', value: widget.episode.airDate),
            const SizedBox(height: 14),
            Text('Participating characters', style: textStyle.titleSmall),
            const SizedBox(height: 10),
            characters.isEmpty
                ? const SizedBox(height: 150, child: LoadingCircular())
                : Expanded(
                    child: ListView.builder(
                      itemCount: characters.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return FadeInRight(
                          child:
                              CardCharacterWidget(character: characters[index]),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
