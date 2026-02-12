import 'package:equatable/equatable.dart';

class TrackDetailEntity extends Equatable {
  const TrackDetailEntity({
    required this.id,
    required this.title,
    required this.artistName,
    required this.albumTitle,
    required this.duration,
    required this.releaseDate,
    required this.previewUrl,
    required this.link,
  });

  final int id;
  final String title;
  final String artistName;
  final String albumTitle;
  final int duration;
  final String releaseDate;
  final String previewUrl;
  final String link;

  @override
  List<Object?> get props => [
        id,
        title,
        artistName,
        albumTitle,
        duration,
        releaseDate,
        previewUrl,
        link,
      ];
}
