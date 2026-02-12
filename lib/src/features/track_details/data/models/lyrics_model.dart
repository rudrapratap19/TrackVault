import '../../domain/entities/lyrics_entity.dart';

class LyricsModel extends LyricsEntity {
  const LyricsModel({required super.lyrics, required super.syncedLyrics});

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
      lyrics: json['lyrics'] as String? ?? '',
      syncedLyrics: json['syncedLyrics'] as String? ?? '',
    );
  }
}
