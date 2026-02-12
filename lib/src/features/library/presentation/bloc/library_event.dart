import 'package:equatable/equatable.dart';

import 'library_state.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LibraryStarted extends LibraryEvent {
  const LibraryStarted();
}

class LibraryLoadMore extends LibraryEvent {
  const LibraryLoadMore();
}

class LibrarySearchChanged extends LibraryEvent {
  const LibrarySearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class LibraryGroupChanged extends LibraryEvent {
  const LibraryGroupChanged(this.groupBy);

  final GroupBy groupBy;

  @override
  List<Object?> get props => [groupBy];
}

  class LibrarySearchApplied extends LibraryEvent {
    const LibrarySearchApplied(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
