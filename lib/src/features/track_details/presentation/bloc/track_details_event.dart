import 'package:equatable/equatable.dart';

import '../../../library/domain/entities/track_entity.dart';

abstract class TrackDetailsEvent extends Equatable {
  const TrackDetailsEvent();

  @override
  List<Object?> get props => [];
}

class TrackDetailsRequested extends TrackDetailsEvent {
  const TrackDetailsRequested(this.track);

  final TrackEntity track;

  @override
  List<Object?> get props => [track];
}
