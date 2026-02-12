import '../../domain/entities/lyrics_entity.dart';
import '../../domain/entities/track_detail_entity.dart';
import '../../domain/repositories/track_details_repository.dart';
import '../datasources/track_details_remote_data_source.dart';

class TrackDetailsRepositoryImpl implements TrackDetailsRepository {
  TrackDetailsRepositoryImpl(this._remote);

  final TrackDetailsRemoteDataSource _remote;

  @override
  Future<TrackDetailEntity> fetchTrackDetails(int id) {
    return _remote.fetchTrackDetails(id);
  }

  @override
  Future<LyricsEntity?> fetchLyrics({
    required String trackName,
    required String artistName,
    required String albumName,
    required int duration,
  }) {
    return _remote.fetchLyrics(
      trackName: trackName,
      artistName: artistName,
      albumName: albumName,
      duration: duration,
    );
  }
}
