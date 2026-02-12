import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../models/lyrics_model.dart';
import '../models/track_detail_model.dart';

class TrackDetailsRemoteDataSource {
  TrackDetailsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<TrackDetailModel> fetchTrackDetails(int id) async {
    final url = Uri.parse('https://api.deezer.com/track/$id');
    final json = await _apiClient.getJson(url);
    return TrackDetailModel.fromJson(json);
  }

  Future<LyricsModel?> fetchLyrics({
    required String trackName,
    required String artistName,
    required String albumName,
    required int duration,
  }) async {
    final url = Uri.https('lrclib.net', '/api/get-cached', {
      'track_name': trackName,
      'artist_name': artistName,
      'album_name': albumName,
      'duration': duration.toString(),
    });
    try {
      final json = await _apiClient.getJson(url);
      if (json.isEmpty) {
        return null;
      }
      return LyricsModel.fromJson(json);
    } on ApiException catch (e) {
      if (e.message.contains('404')) {
        return null;
      }
      rethrow;
    }
  }
}
