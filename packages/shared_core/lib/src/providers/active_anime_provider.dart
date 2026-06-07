import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the ID of the anime the user currently wants to watch.
/// Lives in shared_core so any MFE can read/write to it without coupling.
final activeAnimeIdProvider = StateProvider<int?>((ref) => null);
