class VideoCompletedEvent {
  final String animeId;
  final int episode;

  VideoCompletedEvent(this.animeId, this.episode);
}

class ListUpdatedEvent {
  ListUpdatedEvent();
}

class AnimeSelectedEvent {
  final String animeId;

  AnimeSelectedEvent(this.animeId);
}