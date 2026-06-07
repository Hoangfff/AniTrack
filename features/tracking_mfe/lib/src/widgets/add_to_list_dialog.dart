import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';
import '../controllers/tracking_controller.dart';

class AddToListDialog extends ConsumerStatefulWidget {
  final AnimeModel anime;

  const AddToListDialog({super.key, required this.anime});

  static void show(BuildContext context, AnimeModel anime) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AniTrackColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddToListDialog(anime: anime),
    );
  }

  @override
  ConsumerState<AddToListDialog> createState() => _AddToListDialogState();
}

class _AddToListDialogState extends ConsumerState<AddToListDialog> {
  final TextEditingController _newListController = TextEditingController();

  @override
  void dispose() {
    _newListController.dispose();
    super.dispose();
  }

  void _addToList(String listName) async {
    await TrackingRepository().addAnimeToList(widget.anime, listName);
    eventBus.fire(ListUpdatedEvent());
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thêm vào danh sách $listName!')),
      );
    }
  }

  void _createNewList() async {
    final name = _newListController.text.trim();
    if (name.isNotEmpty) {
      await TrackingRepository().createCustomList(name);
      ref.invalidate(customListsProvider); // Refresh the list provider
      _addToList(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customListsAsync = ref.watch(customListsProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Lưu phim vào danh sách',
            style: AniTrackTypography.headlineMedium,
          ),
          const SizedBox(height: 16),
          
          // Custom lists
          customListsAsync.when(
            data: (lists) {
              if (lists.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('Bạn chưa có danh sách nào.', style: TextStyle(color: AniTrackColors.textMuted)),
                );
              }
              return Column(
                children: lists.map((listName) => ListTile(
                  leading: const Icon(Icons.folder_outlined, color: AniTrackColors.secondary),
                  title: Text(listName),
                  onTap: () => _addToList(listName),
                )).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
          
          // Create new list
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newListController,
                  decoration: InputDecoration(
                    hintText: 'Tạo danh sách mới...',
                    hintStyle: const TextStyle(color: AniTrackColors.textMuted),
                    filled: true,
                    fillColor: AniTrackColors.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _createNewList,
                icon: const Icon(Icons.add_circle, color: AniTrackColors.primary),
              )
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
