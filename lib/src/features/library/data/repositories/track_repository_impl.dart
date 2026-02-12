import '../../domain/entities/track_entity.dart';
import '../../domain/repositories/track_repository.dart';
import '../datasources/deezer_remote_data_source.dart';

class TrackRepositoryImpl implements TrackRepository {
  TrackRepositoryImpl(this._remote);

  final DeezerRemoteDataSource _remote;

  @override
  Future<List<TrackEntity>> fetchTracks({
    required String query,
    required int index,
    required int limit,
  }) async {
    return _remote.fetchTracks(query: query, index: index, limit: limit);
  }
}
