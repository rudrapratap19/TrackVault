import 'package:equatable/equatable.dart';

class TrackEntity extends Equatable {
  const TrackEntity({
    required this.id,
    required this.title,
    required this.artistName,
    required this.albumTitle,
    required this.duration,
  });

  final int id;
  final String title;
  final String artistName;
  final String albumTitle;
  final int duration;

  @override
  List<Object?> get props => [id, title, artistName, albumTitle, duration];
}
