import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/function/get_ids.dart';
import '../../widgets/widgets.dart';

class LocationDetails extends ConsumerStatefulWidget {
  const LocationDetails({super.key, required this.location});

  final LocationModel location;

  @override
  ConsumerState<LocationDetails> createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends ConsumerState<LocationDetails> {
  @override
  void initState() {
    super.initState();
    final ids = getIds(widget.location.residents);
    ref
        .read(charactersPerLocationProvider.notifier)
        .loadCharactersPerEpisode(ids);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final characters = ref.watch(charactersPerLocationProvider);
    return ScaffoldWithAppBar(
      title: 'Location details',
      backButton: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.location.name,
              style: textStyle.titleLarge!.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 10),
            Text('Details', style: textStyle.titleSmall),
            const SizedBox(height: 10),
            ListDetailsWidget(
                title: 'Dimension:', value: widget.location.dimension),
            const SizedBox(height: 8),
            ListDetailsWidget(title: 'Type: ', value: widget.location.type),
            const SizedBox(height: 14),
            Text('Residents', style: textStyle.titleSmall),
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
