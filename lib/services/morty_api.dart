/*
  "characters": "https://rickandmortyapi.com/api/character",
  "locations": "https://rickandmortyapi.com/api/location",
  "episodes": "https://rickandmortyapi.com/api/episode"
*/

import 'dart:developer';

import '../models/models.dart';
import 'config/config_api.dart';

class CharactersApi with DioConfig {
  Future<List<CharactersModel>> getCharacters({int page = 1}) async {
    try {
      final response = await dio.get('/character', queryParameters: {
        'page': page,
      });
      return (response.data['results'] as List)
          .map((e) => CharactersModel.fromJson(e))
          .toList();
    } catch (e) {
      log('$e', name: 'API Characters');
      return [];
    }
  }

  Future<List<CharactersModel>> getCharacterByIds(List<int> id) async {
    try {
      final response = await dio.get('/character/${id.join(',')}');
      if (response.data.runtimeType != List) {
        return [CharactersModel.fromJson(response.data)];
      }
      return (response.data as List)
          .map((e) => CharactersModel.fromJson(e))
          .toList();
    } catch (e) {
      log('$e', name: 'API Characters');
      return [];
    }
  }

  Future<List<CharactersModel>> getCharactersByName(String name) async {
    try {
      final response =
          await dio.get('/character/', queryParameters: {'name': name});
      return (response.data['results'] as List)
          .map((e) => CharactersModel.fromJson(e))
          .toList();
    } catch (e) {
      log('$e', name: 'API Characters');
      return [];
    }
  }
}

class LocationApi with DioConfig {
  Future<List<LocationModel>> getLocations({int page = 1}) async {
    try {
      final response = await dio.get('/location', queryParameters: {
        'page': page,
      });
      return (response.data['results'] as List)
          .map((e) => LocationModel.fromJson(e))
          .toList();
    } catch (e) {
      log('$e', name: 'API Location');
      return [];
    }
  }

  Future<List<LocationModel>> getLocationsByName(String name) async {
    try {
      final response = await dio.get('/location', queryParameters: {
        'name': name,
      });
      return (response.data['results'] as List)
          .map((e) => LocationModel.fromJson(e))
          .toList();
    } catch (e) {
      log('$e', name: 'API Location');
      return [];
    }
  }
}

class EpisodeApi with DioConfig {
  Future<List<EpisodeModel>> getEpisodes({int page = 1}) async {
    try {
      final response = await dio.get('/episode', queryParameters: {
        'page': page,
      });
      return (response.data['results'] as List)
          .map((e) => EpisodeModel.fromJson(e))
          .toList();
    } catch (e) {
      log('$e', name: 'API Episode');
      return [];
    }
  }

  Future<List<EpisodeModel>> getEpisodesPerCharacters(List<int> ids) async {
    try {
      final response = await dio.get('/episode/${ids.join(',')}');

      if (response.data.runtimeType != List) {
        return [EpisodeModel.fromJson(response.data)];
      }
      return (response.data as List)
          .map((e) => EpisodeModel.fromJson(e))
          .toList();
    } catch (e) {
      log('$e', name: 'API Episode');
      return [];
    }
  }

  Future<List<EpisodeModel>> getEpisodesByName(String name) async {
    try {
      final response = await dio.get('/episode', queryParameters: {
        'name': name,
      });
      return (response.data['results'] as List)
          .map((e) => EpisodeModel.fromJson(e))
          .toList();
    } catch (e) {
      log('$e', name: 'API Episode');
      return [];
    }
  }
}
