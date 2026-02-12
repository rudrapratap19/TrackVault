import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../../../core/utils/string_utils.dart';
import '../../domain/entities/track_entity.dart';
import '../../domain/repositories/track_repository.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc(this._repository) : super(LibraryState.initial()) {
    on<LibraryStarted>(_onStarted);
    on<LibraryLoadMore>(_onLoadMore);
    on<LibrarySearchChanged>(_onSearchChanged);
    on<LibrarySearchApplied>(_onSearchApplied);
    on<LibraryGroupChanged>(_onGroupChanged);
  }

  final TrackRepository _repository;
  final List<String> _queries = [
    ...List.generate(26, (i) => String.fromCharCode(97 + i)),
    ...List.generate(10, (i) => '$i'),
    'love',
    'the',
    'you',
    'me',
    'night',
    'day',
    'live',
    'song',
  ];

  static const int _pageSize = 50;

  Timer? _searchDebounce;
  int _currentQueryIndex = 0;
  int _currentIndex = 0;
  bool _isFetching = false;
  final Set<int> _knownIds = <int>{};

  Future<void> _onStarted(
    LibraryStarted event,
    Emitter<LibraryState> emit,
  ) async {
    _currentQueryIndex = 0;
    _currentIndex = 0;
    _knownIds.clear();
    emit(state.copyWith(
      status: LibraryStatus.loading,
      items: [],
      filteredItems: [],
      groups: [],
      hasMore: true,
      isLoadingMore: false,
      errorMessage: null,
      searchTerm: '',
    ));
    await _fetchNextPage(emit, resetError: true);
  }

  Future<void> _onLoadMore(
    LibraryLoadMore event,
    Emitter<LibraryState> emit,
  ) async {
    if (_isFetching || !state.hasMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    await _fetchNextPage(emit, resetError: false);
  }

  void _onSearchChanged(
    LibrarySearchChanged event,
    Emitter<LibraryState> emit,
  ) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      add(LibrarySearchApplied(event.query));
    });
  }

  Future<void> _onSearchApplied(
    LibrarySearchApplied event,
    Emitter<LibraryState> emit,
  ) async {
    final filtered = _applySearch(state.items, event.query);
    final groups = _buildGroups(filtered, state.groupBy);
    emit(state.copyWith(
      status: LibraryStatus.success,
      filteredItems: filtered,
      groups: groups,
      searchTerm: event.query,
    ));
  }

  Future<void> _onGroupChanged(
    LibraryGroupChanged event,
    Emitter<LibraryState> emit,
  ) async {
    final groups = _buildGroups(state.filteredItems, event.groupBy);
    emit(state.copyWith(groupBy: event.groupBy, groups: groups));
  }

  Future<void> _fetchNextPage(
    Emitter<LibraryState> emit, {
    required bool resetError,
  }) async {
    if (_currentQueryIndex >= _queries.length) {
      emit(state.copyWith(
        status: LibraryStatus.success,
        hasMore: false,
        isLoadingMore: false,
      ));
      return;
    }

    _isFetching = true;
    try {
      var fetched = <TrackEntity>[];
      while (fetched.isEmpty && _currentQueryIndex < _queries.length) {
        final query = _queries[_currentQueryIndex];
        fetched = await _repository.fetchTracks(
          query: query,
          index: _currentIndex,
          limit: _pageSize,
        );

        if (fetched.length < _pageSize) {
          _currentQueryIndex += 1;
          _currentIndex = 0;
        } else {
          _currentIndex += _pageSize;
        }
      }

      if (fetched.isEmpty) {
        emit(state.copyWith(
          status: LibraryStatus.success,
          hasMore: false,
          isLoadingMore: false,
        ));
        _isFetching = false;
        return;
      }

      final unique = fetched.where((track) => _knownIds.add(track.id)).toList();
      if (unique.isEmpty) {
        emit(state.copyWith(isLoadingMore: false));
        _isFetching = false;
        return;
      }
      final updatedItems = List<TrackEntity>.from(state.items)..addAll(unique);
      final filtered = _applySearch(updatedItems, state.searchTerm);
      final groups = _buildGroups(filtered, state.groupBy);
      emit(state.copyWith(
        status: LibraryStatus.success,
        items: updatedItems,
        filteredItems: filtered,
        groups: groups,
        isLoadingMore: false,
        hasMore: true,
        errorMessage: resetError ? null : state.errorMessage,
      ));
    } on NoInternetException catch (e) {
      emit(state.copyWith(
        status: LibraryStatus.failure,
        errorMessage: e.message,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: LibraryStatus.failure,
        errorMessage: 'Something went wrong',
        isLoadingMore: false,
      ));
    } finally {
      _isFetching = false;
    }
  }

  List<TrackEntity> _applySearch(List<TrackEntity> items, String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return items;
    }
    return items.where((track) {
      return track.title.toLowerCase().contains(trimmed) ||
          track.artistName.toLowerCase().contains(trimmed) ||
          track.albumTitle.toLowerCase().contains(trimmed) ||
          track.id.toString().contains(trimmed);
    }).toList();
  }

  List<TrackGroup> _buildGroups(List<TrackEntity> items, GroupBy groupBy) {
    final map = <String, List<TrackEntity>>{};
    for (final track in items) {
      final key = groupBy == GroupBy.track
          ? groupKeyFromText(track.title)
          : groupKeyFromText(track.artistName);
      map.putIfAbsent(key, () => []).add(track);
    }
    final sortedKeys = map.keys.toList()..sort();
    return [
      for (final key in sortedKeys)
        TrackGroup(header: key, tracks: map[key] ?? [])
    ];
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
