import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../views.dart';

typedef SearchLocationCallback = Future<List<LocationModel>> Function(
    String query);

typedef LocationsStream = StreamController<List<LocationModel>>;

class SearchLocationDelegate extends SearchDelegate<LocationModel?> {
  SearchLocationDelegate({required this.searchLocationByName})
      : super(searchFieldLabel: 'Search locations');

  SearchLocationCallback searchLocationByName;

  List<LocationModel> initialData = [];

  LocationsStream debounceLocations = StreamController.broadcast();

  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  void clearStreams() {
    debounceLocations.close();
  }

  void _onQueryChanged(String query) {
    if (query.isEmpty) return;
    if (query.isNotEmpty) isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final locations = await searchLocationByName(query);

      initialData.addAll(locations);
      debounceLocations.add(locations);

      isLoadingStream.add(false);
    });
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder<List<LocationModel>>(
      initialData: initialData,
      stream: debounceLocations.stream,
      builder: (context, snapshot) {
        final locations = snapshot.data ?? [];

        if (locations.isEmpty) {
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
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final location = locations[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return LocationDetails(
                    location: location,
                  );
                }));
              },
              child: FadeIn(
                child: CardView(
                  title: location.name,
                  subtitle: location.type,
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
