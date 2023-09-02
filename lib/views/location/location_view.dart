import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../delegate/search_location_delegate.dart';
import '../views.dart';

class LocationView extends ConsumerStatefulWidget {
  const LocationView({super.key});

  @override
  ConsumerState<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends ConsumerState<LocationView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(locationProvider.notifier).loadNextPage();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 300) >=
          scrollController.position.maxScrollExtent) {
        ref.read(locationProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationProvider);

    return locations.isNotEmpty
        ? ScaffoldWithAppBar(
            title: 'Location',
            onPressedSearch: () => showSearch(
              context: context,
              delegate: SearchLocationDelegate(
                searchLocationByName:
                    ref.read(locationProvider.notifier).searchLocationByName,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        return FadeInUp(
                          child: _LocationCard(
                            location: locations[index],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        : const LoadingCircular();
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.location});

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    return CardView(
      title: location.name,
      subtitle: location.type,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LocationDetails(
            location: location,
          ),
        ),
      ),
    );
  }
}
