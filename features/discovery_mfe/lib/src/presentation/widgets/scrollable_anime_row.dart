import 'dart:ui';
import 'package:discovery_mfe/src/presentation/widgets/anime_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';

import 'anime_card.dart';

class ScrollableAnimeRow extends StatefulWidget {
  final List<AnimeModel> animeList;

  const ScrollableAnimeRow({super.key, required this.animeList});

  @override
  State<ScrollableAnimeRow> createState() => _ScrollableAnimeRowState();
}

class _ScrollableAnimeRowState extends State<ScrollableAnimeRow> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftButton = false;
  bool _showRightButton = false;

  static const double _itemWidth = 180.0;
  static const double _scrollAmount = 600.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateButtons);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateButtons();
    });
  }

  @override
  void didUpdateWidget(covariant ScrollableAnimeRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animeList != oldWidget.animeList) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _updateButtons();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateButtons);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateButtons() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final canScrollLeft = position.pixels > 0;
    final canScrollRight = position.pixels < position.maxScrollExtent;

    if (_showLeftButton != canScrollLeft ||
        _showRightButton != canScrollRight) {
      setState(() {
        _showLeftButton = canScrollLeft;
        _showRightButton = canScrollRight;
      });
    }
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      (_scrollController.position.pixels - _scrollAmount).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      (_scrollController.position.pixels + _scrollAmount).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animeList.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: Text(
            'No anime found',
            style: TextStyle(color: AniTrackColors.textMuted),
          ),
        ),
      );
    }

    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AniTrackSpacing.lg,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: widget.animeList.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AniTrackSpacing.md),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: _itemWidth,
                  child: InkWell(
                    onTap: () {
                      AnimeDetailsModal.show(context, widget.animeList[index]);
                    },
                    borderRadius: AniTrackSpacing.radiusMedium,
                    child: AnimeCard(anime: widget.animeList[index]),
                  ),
                );
              },
            ),
          ),

          if (_showLeftButton)
            Positioned(
              left: 4,
              top: 0,
              bottom: 0,
              child: _buildNavButton(
                icon: Icons.chevron_left_rounded,
                onPressed: _scrollLeft,
              ),
            ),

          if (_showRightButton)
            Positioned(
              right: 4,
              top: 0,
              bottom: 0,
              child: _buildNavButton(
                icon: Icons.chevron_right_rounded,
                onPressed: _scrollRight,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AniTrackColors.background.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, size: 36),
          color: AniTrackColors.primary,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
