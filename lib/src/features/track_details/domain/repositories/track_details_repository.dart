import '../entities/lyrics_entity.dart';
import '../entities/track_detail_entity.dart';

abstract class TrackDetailsRepository {
  Future<TrackDetailEntity> fetchTrackDetails(int id);

  Future<LyricsEntity?> fetchLyrics({
    required String trackName,
    required String artistName,
    required String albumName,
    required int duration,
  });
}
