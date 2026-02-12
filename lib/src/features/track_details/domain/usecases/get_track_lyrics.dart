import '../entities/lyrics_entity.dart';
import '../repositories/track_details_repository.dart';

class GetTrackLyrics {
  GetTrackLyrics(this.repository);

  final TrackDetailsRepository repository;

  Future<LyricsEntity?> call({
    required String trackName,
    required String artistName,
    required String albumName,
    required int duration,
  }) {
    return repository.fetchLyrics(
      trackName: trackName,
      artistName: artistName,
      albumName: albumName,
      duration: duration,
    );
  }
}
