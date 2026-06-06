import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:discovery_mfe/discovery_mfe.dart';
import 'package:player_mfe/player_mfe.dart';
import 'package:shared_core/shared_core.dart';

import '../providers/navigation_provider.dart';
import 'anitrack_sidebar.dart';

/// Top-level layout: sidebar on the left, content on the right.
///
/// The content area switches based on the selected tab from
/// [selectedTabProvider]. Currently shows placeholder screens;
/// real MFE screens will replace them later.
class AniTrackScaffold extends ConsumerWidget {
  const AniTrackScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return Scaffold(
      body: Row(
        children: [
          const AniTrackSidebar(),
          Expanded(
            child: AnimatedSwitcher(
              duration: AniTrackSpacing.animNormal,
              child: _buildContent(selectedTab, ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(int selectedTab, WidgetRef ref) {
    return switch (selectedTab) {
      0 => const DiscoveryScreen(
        key: ValueKey('discovery'),
      ),
      1 => const _PlaceholderScreen(
        key: ValueKey('search'),
        title: 'Search',
        subtitle: 'Find and browse anime series',
        icon: Icons.search_rounded,
      ),
      2 => AnimePlayerScreen(
        key: ValueKey('watch'),
        malId: ref.read(activeAnimeIdProvider),
      ),
      3 => const _PlaceholderScreen(
        key: ValueKey('profile'),
        title: 'Profile',
        subtitle: 'Your info, playlists, and settings',
        icon: Icons.person_outline_rounded,
      ),
      _ => const _PlaceholderScreen(
        key: ValueKey('home'),
        title: 'Home',
        subtitle: 'Posts, announcements, and featured content',
        icon: Icons.home_rounded,
      ),
    };
  }
}

/// Temporary placeholder shown for each tab until MFE screens are built.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing icon circle
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AniTrackColors.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: AniTrackColors.primary.withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, size: 44, color: AniTrackColors.primary),
          ),
          const SizedBox(height: AniTrackSpacing.xl),
          Text(
            title,
            style: AniTrackTypography.headlineLarge.copyWith(
              color: AniTrackColors.onBackground,
            ),
          ),
          const SizedBox(height: AniTrackSpacing.xs),
          Text(
            subtitle,
            style: AniTrackTypography.bodyMedium.copyWith(
              color: AniTrackColors.textMuted,
            ),
          ),
          const SizedBox(height: AniTrackSpacing.xxl),
          Text(
            'Coming soon',
            style: AniTrackTypography.labelMedium.copyWith(
              color: AniTrackColors.textDisabled,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
