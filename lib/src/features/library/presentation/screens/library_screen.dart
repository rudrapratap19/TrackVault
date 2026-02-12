import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/status_message.dart';
import '../../../track_details/presentation/screens/track_details_screen.dart';
import '../../domain/entities/track_entity.dart';
import '../bloc/library_bloc.dart';
import '../bloc/library_event.dart';
import '../bloc/library_state.dart';
import '../widgets/library_search_bar.dart';
import '../widgets/track_group_header.dart';
import '../widgets/track_list_item.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<LibraryBloc>().add(const LibraryLoadMore());
    }
  }

  void _openDetails(TrackEntity track) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TrackDetailsScreen(track: track),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LibraryBloc, LibraryState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage &&
            current.errorMessage != null &&
            current.items.isNotEmpty;
      },
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('TrackVault Library')),
        body: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state.status == LibraryStatus.loading && state.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == LibraryStatus.failure && state.items.isEmpty) {
              return StatusMessage(message: state.errorMessage ?? 'Error');
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: LibrarySearchBar(
                    onSearchChanged: (value) =>
                        context.read<LibraryBloc>().add(
                              LibrarySearchChanged(value),
                            ),
                    onGroupChanged: (value) =>
                        context.read<LibraryBloc>().add(
                              LibraryGroupChanged(value),
                            ),
                    groupBy: state.groupBy,
                  ),
                ),
                if (state.filteredItems.isEmpty)
                  const SliverFillRemaining(
                    child: StatusMessage(message: 'No tracks found'),
                  )
                else
                  for (final group in state.groups) ...[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: TrackGroupHeaderDelegate(title: group.header),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final track = group.tracks[index];
                          return TrackListItem(
                            track: track,
                            onTap: () => _openDetails(track),
                          );
                        },
                        childCount: group.tracks.length,
                      ),
                    ),
                  ],
                SliverToBoxAdapter(
                  child: state.isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox(height: 16),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
