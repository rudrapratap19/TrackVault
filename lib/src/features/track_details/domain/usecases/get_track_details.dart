import '../entities/track_detail_entity.dart';
import '../repositories/track_details_repository.dart';

class GetTrackDetails {
  GetTrackDetails(this.repository);

  final TrackDetailsRepository repository;

  Future<TrackDetailEntity> call(int id) {
    return repository.fetchTrackDetails(id);
  }
}
