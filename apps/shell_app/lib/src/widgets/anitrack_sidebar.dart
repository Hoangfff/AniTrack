import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';

import '../providers/navigation_provider.dart';

/// Navigation item definition.
class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// Collapsible sidebar navigation for AniTrack.
///
/// Supports expanded (icon + label) and collapsed (icon-only with tooltips)
/// states. Contains a branded header, four navigation items, and a
/// dark-mode toggle at the bottom.
class AniTrackSidebar extends ConsumerWidget {
  const AniTrackSidebar({super.key});

  static const _navItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.search_rounded, label: 'Search'),
    _NavItem(icon: Icons.play_circle_outline_rounded, label: 'Watch'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(sidebarExpandedProvider);
    final selectedTab = ref.watch(selectedTabProvider);

    return AnimatedContainer(
      duration: AniTrackSpacing.animNormal,
      curve: Curves.easeInOutCubic,
      width: isExpanded
          ? AniTrackSpacing.sidebarExpanded
          : AniTrackSpacing.sidebarCollapsed,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: AniTrackColors.surface,
        border: Border(right: BorderSide(color: AniTrackColors.border)),
      ),
      child: Column(
        children: [
          // ── Header (branding + toggle) ──
          _buildHeader(ref, isExpanded),
          const Divider(),
          const SizedBox(height: AniTrackSpacing.xs),

          // ── Navigation items ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AniTrackSpacing.xs,
              ),
              child: Column(
                children: List.generate(_navItems.length, (index) {
                  return _buildNavItem(
                    ref,
                    _navItems[index],
                    index,
                    isSelected: selectedTab == index,
                    isExpanded: isExpanded,
                  );
                }),
              ),
            ),
          ),

          // ── Bottom section ──
          const Divider(),
          _buildThemeToggle(isExpanded),
          const SizedBox(height: AniTrackSpacing.sm),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────
  //  Header
  // ────────────────────────────────────────────

  Widget _buildHeader(WidgetRef ref, bool isExpanded) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isExpanded ? AniTrackSpacing.sm : AniTrackSpacing.xs,
        vertical: AniTrackSpacing.sm,
      ),
      child: isExpanded ? _expandedHeader(ref) : _collapsedHeader(ref),
    );
  }

  Widget _expandedHeader(WidgetRef ref) {
    return Row(
      children: [
        _buildLogo(),
        const SizedBox(width: AniTrackSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AniTrack',
                style: AniTrackTypography.titleMedium.copyWith(
                  color: AniTrackColors.onBackground,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Anime Streaming',
                style: AniTrackTypography.bodySmall.copyWith(
                  color: AniTrackColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildToggleButton(ref, isExpanded: true),
      ],
    );
  }

  Widget _collapsedHeader(WidgetRef ref) {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: AniTrackSpacing.xs),
        _buildToggleButton(ref, isExpanded: false),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AniTrackColors.primary, AniTrackColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AniTrackSpacing.radiusMedium,
      ),
      child: Center(
        child: Text(
          'AT',
          style: AniTrackTypography.labelLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(WidgetRef ref, {required bool isExpanded}) {
    return IconButton(
      onPressed: () {
        ref.read(sidebarExpandedProvider.notifier).state = !isExpanded;
      },
      tooltip: isExpanded ? 'Collapse sidebar' : 'Expand sidebar',
      icon: AnimatedRotation(
        turns: isExpanded ? 0 : 0.5,
        duration: AniTrackSpacing.animNormal,
        child: const Icon(Icons.chevron_left_rounded, size: 20),
      ),
      style: IconButton.styleFrom(
        foregroundColor: AniTrackColors.textMuted,
        backgroundColor: AniTrackColors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: AniTrackSpacing.radiusSmall,
        ),
        minimumSize: const Size(32, 32),
        maximumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
      ),
    );
  }

  // ────────────────────────────────────────────
  //  Navigation items
  // ────────────────────────────────────────────

  Widget _buildNavItem(
    WidgetRef ref,
    _NavItem item,
    int index, {
    required bool isSelected,
    required bool isExpanded,
  }) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(selectedTabProvider.notifier).state = index;
          },
          borderRadius: AniTrackSpacing.radiusMedium,
          hoverColor: AniTrackColors.surfaceVariant,
          splashColor: AniTrackColors.primary.withOpacity(0.1),
          child: AnimatedContainer(
            duration: AniTrackSpacing.animFast,
            padding: EdgeInsets.symmetric(
              horizontal: AniTrackSpacing.sm,
              vertical: AniTrackSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AniTrackColors.secondaryContainer
                  : Colors.transparent,
              borderRadius: AniTrackSpacing.radiusMedium,
            ),
            child: Row(
              mainAxisAlignment: isExpanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 22,
                  color: isSelected
                      ? AniTrackColors.secondary
                      : AniTrackColors.textMuted,
                ),
                if (isExpanded) ...[
                  const SizedBox(width: AniTrackSpacing.sm),
                  Expanded(
                    child: Text(
                      item.label,
                      style: AniTrackTypography.titleSmall.copyWith(
                        color: isSelected
                            ? AniTrackColors.onBackground
                            : AniTrackColors.textMuted,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    // Show tooltip when collapsed so the user knows what each icon means.
    if (!isExpanded) {
      return Tooltip(message: item.label, child: child);
    }
    return child;
  }

  // ────────────────────────────────────────────
  //  Theme toggle
  // ────────────────────────────────────────────

  Widget _buildThemeToggle(bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AniTrackSpacing.sm),
      child: Row(
        mainAxisAlignment: isExpanded
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.dark_mode_rounded,
            size: 20,
            color: AniTrackColors.textMuted,
          ),
          if (isExpanded) ...[
            const SizedBox(width: AniTrackSpacing.sm),
            Expanded(
              child: Text(
                'Dark Mode',
                style: AniTrackTypography.bodySmall.copyWith(
                  color: AniTrackColors.textMuted,
                ),
              ),
            ),
            Switch(
              value: true,
              onChanged: (_) {
                // TODO: Wire up theme switching when light theme is ready.
              },
            ),
          ],
        ],
      ),
    );
  }
}
