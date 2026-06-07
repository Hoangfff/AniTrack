import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

class TrackingListNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final String status;
  final TrackingRepository _repository = TrackingRepository();

  TrackingListNotifier(this.status) : super(const AsyncValue.loading()) {
    loadList();
    _listenToEventBus();
  }

  Future<void> loadList() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getSavedList(status);
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _listenToEventBus() {
    eventBus.on<ListUpdatedEvent>().listen((_) {
      loadList();
    });

    if (status == 'Watching') {
      // Khi có phim xem xong, tự động lưu tiến độ
      eventBus.on<VideoCompletedEvent>().listen((event) async {
        await _repository.updateEpisodeProgress(event.animeId, event.episode);
        loadList(); // Cập nhật lại UI
        eventBus.fire(ListUpdatedEvent()); // Báo cho các nơi khác
      });
    }
  }

  Future<void> addAnime(AnimeModel anime) async {
    await _repository.addAnimeToList(anime, status);
    loadList();
    eventBus.fire(ListUpdatedEvent());
  }
}

// Các provider tương ứng cho 3 tab
final watchingProvider = StateNotifierProvider<TrackingListNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return TrackingListNotifier('Watching');
});

final completedProvider = StateNotifierProvider<TrackingListNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return TrackingListNotifier('Completed');
});

final planProvider = StateNotifierProvider<TrackingListNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return TrackingListNotifier('Plan to Watch');
});

final trackingUpdateCounterProvider = StateProvider<int>((ref) => 0);

// Provides the list of custom list names
final customListsProvider = FutureProvider<List<String>>((ref) async {
  ref.watch(trackingUpdateCounterProvider);
  return TrackingRepository().getCustomLists();
});

// Provides items for a specific custom list
final customListItemsProvider = StateNotifierProvider.family<TrackingListNotifier, AsyncValue<List<Map<String, dynamic>>>, String>((ref, listName) {
  return TrackingListNotifier(listName);
});
