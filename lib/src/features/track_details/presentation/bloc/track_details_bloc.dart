import 'package:bloc/bloc.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../../library/domain/entities/track_entity.dart';
import '../../domain/entities/track_detail_entity.dart';
import '../../domain/repositories/track_details_repository.dart';
import 'track_details_event.dart';
import 'track_details_state.dart';

class TrackDetailsBloc extends Bloc<TrackDetailsEvent, TrackDetailsState> {
  TrackDetailsBloc(this._repository) : super(TrackDetailsState.initial()) {
    on<TrackDetailsRequested>(_onRequested);
  }

  final TrackDetailsRepository _repository;

  Future<void> _onRequested(
    TrackDetailsRequested event,
    Emitter<TrackDetailsState> emit,
  ) async {
    emit(state.copyWith(
      detailsStatus: DetailsStatus.loading,
      lyricsStatus: LyricsStatus.initial,
      errorMessage: null,
      lyricsErrorMessage: null,
    ));

    try {
      final details = await _repository.fetchTrackDetails(event.track.id);
      emit(state.copyWith(
        detailsStatus: DetailsStatus.success,
        details: details,
      ));
      await _fetchLyrics(event.track, details, emit);
    } on NoInternetException catch (e) {
      emit(state.copyWith(
        detailsStatus: DetailsStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        detailsStatus: DetailsStatus.failure,
        errorMessage: 'Something went wrong',
      ));
    }
  }

  Future<void> _fetchLyrics(
    TrackEntity track,
    TrackDetailEntity details,
    Emitter<TrackDetailsState> emit,
  ) async {
    emit(state.copyWith(lyricsStatus: LyricsStatus.loading));
    try {
      final lyrics = await _repository.fetchLyrics(
        trackName: details.title,
        artistName: details.artistName,
        albumName: details.albumTitle,
        duration: details.duration,
      );
      if (lyrics == null ||
          (lyrics.lyrics.isEmpty && lyrics.syncedLyrics.isEmpty)) {
        emit(state.copyWith(lyricsStatus: LyricsStatus.empty));
      } else {
        emit(state.copyWith(
          lyricsStatus: LyricsStatus.success,
          lyrics: lyrics,
        ));
      }
    } on NoInternetException catch (e) {
      emit(state.copyWith(
        lyricsStatus: LyricsStatus.failure,
        lyricsErrorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        lyricsStatus: LyricsStatus.failure,
        lyricsErrorMessage: 'Lyrics unavailable',
      ));
    }
  }
}
