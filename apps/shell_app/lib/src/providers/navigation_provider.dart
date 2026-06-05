import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the sidebar is in its expanded (labels visible) state.
final sidebarExpandedProvider = StateProvider<bool>((ref) => true);

/// Index of the currently active navigation tab.
///
/// 0 = Home, 1 = Search, 2 = Watch, 3 = Profile
final selectedTabProvider = StateProvider<int>((ref) => 0);
