import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../location/location_api_impl.dart';

final searchedLocationProvider =
    StateNotifierProvider<SearchLocationNotifier, List<LocationModel>>((ref) {
  return SearchLocationNotifier(ref: ref);
});

typedef SearchLocationCallback = Future<List<LocationModel>> Function(
    String query);

class SearchLocationNotifier extends StateNotifier<List<LocationModel>> {
  SearchLocationNotifier({required this.ref}) : super([]);

  final Ref ref;

  Future<List<LocationModel>> searchLocationByQuery(String query) async {
    final List<LocationModel> location =
        await ref.read(locationApiProvider).getLocationsByName(query);
    state = location;
    return location;
  }
}
