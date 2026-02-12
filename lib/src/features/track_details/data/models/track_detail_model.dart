import '../../domain/entities/track_detail_entity.dart';

class TrackDetailModel extends TrackDetailEntity {
  const TrackDetailModel({
    required super.id,
    required super.title,
    required super.artistName,
    required super.albumTitle,
    required super.duration,
    required super.releaseDate,
    required super.previewUrl,
    required super.link,
  });

  factory TrackDetailModel.fromJson(Map<String, dynamic> json) {
    final artist = json['artist'] as Map<String, dynamic>?;
    final album = json['album'] as Map<String, dynamic>?;
    return TrackDetailModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Unknown',
      artistName: artist?['name'] as String? ?? 'Unknown',
      albumTitle: album?['title'] as String? ?? 'Unknown',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      releaseDate: json['release_date'] as String? ?? 'Unknown',
      previewUrl: json['preview'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }
}
