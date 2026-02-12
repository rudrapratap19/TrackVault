import 'package:equatable/equatable.dart';

import '../../domain/entities/lyrics_entity.dart';
import '../../domain/entities/track_detail_entity.dart';

enum DetailsStatus { initial, loading, success, failure }

enum LyricsStatus { initial, loading, success, failure, empty }

class TrackDetailsState extends Equatable {
  const TrackDetailsState({
    required this.detailsStatus,
    required this.lyricsStatus,
    this.details,
    this.lyrics,
    this.errorMessage,
    this.lyricsErrorMessage,
  });

  final DetailsStatus detailsStatus;
  final LyricsStatus lyricsStatus;
  final TrackDetailEntity? details;
  final LyricsEntity? lyrics;
  final String? errorMessage;
  final String? lyricsErrorMessage;

  TrackDetailsState copyWith({
    DetailsStatus? detailsStatus,
    LyricsStatus? lyricsStatus,
    TrackDetailEntity? details,
    LyricsEntity? lyrics,
    String? errorMessage,
    String? lyricsErrorMessage,
  }) {
    return TrackDetailsState(
      detailsStatus: detailsStatus ?? this.detailsStatus,
      lyricsStatus: lyricsStatus ?? this.lyricsStatus,
      details: details ?? this.details,
      lyrics: lyrics ?? this.lyrics,
      errorMessage: errorMessage,
      lyricsErrorMessage: lyricsErrorMessage,
    );
  }

  factory TrackDetailsState.initial() {
    return const TrackDetailsState(
      detailsStatus: DetailsStatus.initial,
      lyricsStatus: LyricsStatus.initial,
    );
  }

  @override
  List<Object?> get props => [
        detailsStatus,
        lyricsStatus,
        details,
        lyrics,
        errorMessage,
        lyricsErrorMessage,
      ];
}
