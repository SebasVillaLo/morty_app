import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/morty_api.dart';

final charactersApiProvider = Provider<CharactersApi>(
  (ref) => CharactersApi(),
);
