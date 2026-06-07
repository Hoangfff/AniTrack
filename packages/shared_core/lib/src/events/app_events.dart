class VideoCompletedEvent {
  final String animeId;
  final int episode;

  VideoCompletedEvent(this.animeId, this.episode);
}

class ListUpdatedEvent {
  ListUpdatedEvent();
}

class AnimeSelectedEvent {
  final int malId;
  AnimeSelectedEvent(this.malId);
}

class ShowAddToListDialogEvent {
  final dynamic anime; // dynamic to avoid cyclical dependency, or import AnimeModel
  ShowAddToListDialogEvent(this.anime);
}
