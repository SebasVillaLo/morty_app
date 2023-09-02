import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../services/morty_api.dart';
import 'location_api_impl.dart';

final locationProvider =
    StateNotifierProvider<LocationNotifier, List<LocationModel>>((ref) {
  final api = ref.read(locationApiProvider);
  return LocationNotifier(api);
});

class LocationNotifier extends StateNotifier<List<LocationModel>> {
  LocationNotifier(this.api) : super([]);

  final LocationApi api;

  int _currentPage = 0;
  bool _isLoading = false;

  Future<void> loadNextPage() async {
    if (_isLoading) return;
    _isLoading = true;

    _currentPage++;
    final locations = await api.getLocations(page: _currentPage);
    state = [...state, ...locations];
    _isLoading = false;
  }

  Future<List<LocationModel>> searchLocationByName(String query) async {
    final locations = await api.getLocationsByName(query);
    return locations;
  }
}
