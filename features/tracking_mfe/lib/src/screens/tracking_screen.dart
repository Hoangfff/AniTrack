import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';
import '../controllers/tracking_controller.dart';
import '../widgets/tracking_anime_card.dart';
import '../widgets/add_to_list_dialog.dart';
import 'package:shared_core/shared_core.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện của tôi'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AniTrackColors.primary,
          labelColor: AniTrackColors.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Đang xem'),
            Tab(text: 'Đã hoàn thành'),
            Tab(text: 'Danh sách của tôi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _TrackingGrid(providerType: 'Watching'),
          _TrackingGrid(providerType: 'Completed'),
          _MyListsTab(),
        ],
      ),
    );
  }
}

class _TrackingGrid extends ConsumerWidget {
  final String providerType;
  const _TrackingGrid({required this.providerType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = providerType == 'Watching'
        ? watchingProvider
        : providerType == 'Completed'
            ? completedProvider
            : customListItemsProvider(providerType);

    final state = ref.watch(provider);

    return state.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text(
              'Danh sách trống.\nHãy tìm phim và lưu vào đây nhé!',
              textAlign: TextAlign.center,
              style: AniTrackTypography.bodyMedium.copyWith(color: Colors.grey),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return TrackingAnimeCard(data: list[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Lỗi: $e')),
    );
  }
}

class _MyListsTab extends ConsumerStatefulWidget {
  const _MyListsTab();
  @override
  ConsumerState<_MyListsTab> createState() => _MyListsTabState();
}

class _MyListsTabState extends ConsumerState<_MyListsTab> {
  String _searchQuery = '';
  String? _selectedList;
  final JikanRepository _jikanRepo = JikanRepository();

  @override
  Widget build(BuildContext context) {
    if (_selectedList != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _selectedList = null),
                  icon: const Icon(Icons.arrow_back),
                  color: AniTrackColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedList!,
                  style: AniTrackTypography.headlineMedium,
                ),
              ],
            ),
          ),
          Expanded(child: _TrackingGrid(providerType: _selectedList!)),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'Tìm kiếm Anime...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AniTrackColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: _searchQuery.isNotEmpty
              ? _buildSearchResults()
              : _buildCustomLists(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<AnimeModel>>(
      future: _jikanRepo.searchAnime(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Lỗi tìm kiếm'));
        }
        final list = snapshot.data ?? [];
        if (list.isEmpty) {
          return const Center(child: Text('Không tìm thấy anime.', style: TextStyle(color: AniTrackColors.textMuted)));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final anime = list[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Mở Dialog thêm vào list
                  AddToListDialog.show(context, anime);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AniTrackColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: anime.imageUrl.isNotEmpty
                              ? Image.network(anime.imageUrl, fit: BoxFit.cover, width: double.infinity)
                              : Container(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          anime.title,
                          style: AniTrackTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCustomLists() {
    final customListsAsync = ref.watch(customListsProvider);
    return Column(
      children: [
        // Nút tạo danh sách mới
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            onPressed: () => _showCreateListDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Tạo danh sách mới'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AniTrackColors.primary,
              foregroundColor: AniTrackColors.onPrimary,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: customListsAsync.when(
            data: (lists) {
              if (lists.isEmpty) {
                return Center(
                  child: Text(
                    'Bạn chưa có danh sách nào.',
                    textAlign: TextAlign.center,
                    style: AniTrackTypography.bodyMedium.copyWith(color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final listName = lists[index];
                  return Card(
                    color: AniTrackColors.surfaceVariant,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.folder, color: AniTrackColors.secondary),
                      title: Text(listName, style: AniTrackTypography.titleMedium),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        setState(() {
                          _selectedList = listName;
                        });
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Lỗi tải danh sách')),
          ),
        ),
      ],
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AniTrackColors.surface,
        title: Text('Tạo danh sách mới', style: AniTrackTypography.headlineMedium),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Nhập tên danh sách...',
            filled: true,
            fillColor: AniTrackColors.surfaceVariant,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy', style: TextStyle(color: AniTrackColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                await TrackingRepository().createCustomList(name);
                ref.invalidate(customListsProvider);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AniTrackColors.primary),
            child: const Text('Tạo', style: TextStyle(color: AniTrackColors.onPrimary)),
          ),
        ],
      ),
    );
  }
}
