import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../views.dart';

class CharactersDetails extends StatelessWidget {
  const CharactersDetails({super.key, required this.character});

  final CharactersModel character;

  List<int> getIdsEpisodes() {
    final ids = <int>[];
    for (var element in character.episode) {
      final id = element.split('/').last;
      ids.add(int.parse(id));
    }
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return ScaffoldWithAppBar(
      title: character.name,
      backButton: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeIn(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.white.withOpacity(0.08),
                  //     blurRadius: 10,
                  //     offset: const Offset(0, 5),
                  //   )
                  // ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    character.image,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(character.name,
                      style: textStyle.titleLarge!.copyWith(fontSize: 28)),
                  const SizedBox(height: 10),
                  Text('Details', style: textStyle.titleSmall),
                  const SizedBox(height: 10),
                  ListDetailsWidget(
                      title: 'Species:', value: character.species),
                  const SizedBox(height: 8),
                  ListDetailsWidget(title: 'Gender: ', value: character.gender),
                  const SizedBox(height: 8),
                  ListDetailsWidget(title: 'Status: ', value: character.status),
                  const SizedBox(height: 8),
                  ListDetailsWidget(
                      title: 'Origin: ', value: character.origin.name!),
                  const SizedBox(height: 14),
                  Text('Episodes in which it appears',
                      style: textStyle.titleSmall),
                  const SizedBox(height: 10),
                  CardView(
                    title: 'Episodes',
                    subtitle: character.episode.length.toString(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EpisodeView(
                          idsEpisodes: getIdsEpisodes(),
                          nameCharacter: character.name,
                          key: const PageStorageKey('episodesPerCharacters'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
