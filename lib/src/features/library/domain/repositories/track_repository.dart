import '../entities/track_entity.dart';

abstract class TrackRepository {
  Future<List<TrackEntity>> fetchTracks({
    required String query,
    required int index,
    required int limit,
  });
}
