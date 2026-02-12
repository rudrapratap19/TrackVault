import 'package:equatable/equatable.dart';

import '../../domain/entities/track_entity.dart';

enum LibraryStatus { initial, loading, success, failure }

enum GroupBy { track, artist }

class TrackGroup extends Equatable {
  const TrackGroup({required this.header, required this.tracks});

  final String header;
  final List<TrackEntity> tracks;

  @override
  List<Object?> get props => [header, tracks];
}

class LibraryState extends Equatable {
  const LibraryState({
    required this.status,
    required this.items,
    required this.filteredItems,
    required this.groups,
    required this.hasMore,
    required this.isLoadingMore,
    required this.groupBy,
    required this.searchTerm,
    this.errorMessage,
  });

  final LibraryStatus status;
  final List<TrackEntity> items;
  final List<TrackEntity> filteredItems;
  final List<TrackGroup> groups;
  final bool hasMore;
  final bool isLoadingMore;
  final GroupBy groupBy;
  final String searchTerm;
  final String? errorMessage;

  LibraryState copyWith({
    LibraryStatus? status,
    List<TrackEntity>? items,
    List<TrackEntity>? filteredItems,
    List<TrackGroup>? groups,
    bool? hasMore,
    bool? isLoadingMore,
    GroupBy? groupBy,
    String? searchTerm,
    String? errorMessage,
  }) {
    return LibraryState(
      status: status ?? this.status,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      groups: groups ?? this.groups,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      groupBy: groupBy ?? this.groupBy,
      searchTerm: searchTerm ?? this.searchTerm,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        filteredItems,
        groups,
        hasMore,
        isLoadingMore,
        groupBy,
        searchTerm,
        errorMessage,
      ];

  factory LibraryState.initial() {
    return const LibraryState(
      status: LibraryStatus.initial,
      items: [],
      filteredItems: [],
      groups: [],
      hasMore: true,
      isLoadingMore: false,
      groupBy: GroupBy.track,
      searchTerm: '',
      errorMessage: null,
    );
  }
}
