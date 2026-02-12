import 'package:equatable/equatable.dart';

class LyricsEntity extends Equatable {
  const LyricsEntity({required this.lyrics, required this.syncedLyrics});

  final String lyrics;
  final String syncedLyrics;

  @override
  List<Object?> get props => [lyrics, syncedLyrics];
}
