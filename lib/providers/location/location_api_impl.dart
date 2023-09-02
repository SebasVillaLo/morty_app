import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/morty_api.dart';

final locationApiProvider = Provider<LocationApi>(
  (ref) => LocationApi(),
);
