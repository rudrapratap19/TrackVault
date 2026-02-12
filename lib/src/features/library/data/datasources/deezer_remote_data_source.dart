import '../../../../core/network/api_client.dart';
import '../models/track_model.dart';

class DeezerRemoteDataSource {
  DeezerRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<TrackModel>> fetchTracks({
    required String query,
    required int index,
    required int limit,
  }) async {
    final url = Uri.parse(
      'https://api.deezer.com/search/track?q=$query&index=$index&limit=$limit',
    );
    final json = await _apiClient.getJson(url);
    final data = json['data'];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(TrackModel.fromJson)
          .toList();
    }
    return [];
  }
}
