class VideoCompletedEvent {
  final String animeId;
  final int episode;

  VideoCompletedEvent(this.animeId, this.episode);
}

class ListUpdatedEvent {
  ListUpdatedEvent();
}
