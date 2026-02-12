import '../../domain/entities/track_entity.dart';

class TrackModel extends TrackEntity {
  const TrackModel({
    required super.id,
    required super.title,
    required super.artistName,
    required super.albumTitle,
    required super.duration,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    final artist = json['artist'] as Map<String, dynamic>?;
    final album = json['album'] as Map<String, dynamic>?;
    return TrackModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Unknown',
      artistName: artist?['name'] as String? ?? 'Unknown',
      albumTitle: album?['title'] as String? ?? 'Unknown',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
    );
  }
}
