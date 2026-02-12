import '../entities/track_entity.dart';
import '../repositories/track_repository.dart';

class FetchTracksPage {
  FetchTracksPage(this.repository);

  final TrackRepository repository;

  Future<List<TrackEntity>> call({
    required String query,
    required int index,
    required int limit,
  }) {
    return repository.fetchTracks(query: query, index: index, limit: limit);
  }
}
