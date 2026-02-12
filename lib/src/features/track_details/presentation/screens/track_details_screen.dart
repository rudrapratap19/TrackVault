import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/status_message.dart';
import '../../../library/domain/entities/track_entity.dart';
import '../../domain/repositories/track_details_repository.dart';
import '../bloc/track_details_bloc.dart';
import '../bloc/track_details_event.dart';
import '../bloc/track_details_state.dart';

class TrackDetailsScreen extends StatelessWidget {
  const TrackDetailsScreen({super.key, required this.track});

  final TrackEntity track;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrackDetailsBloc(
        context.read<TrackDetailsRepository>(),
      )..add(TrackDetailsRequested(track)),
      child: Scaffold(
        appBar: AppBar(title: Text(track.title)),
        body: BlocBuilder<TrackDetailsBloc, TrackDetailsState>(
          builder: (context, state) {
            if (state.detailsStatus == DetailsStatus.loading ||
                state.detailsStatus == DetailsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.detailsStatus == DetailsStatus.failure) {
              return StatusMessage(
                message: state.errorMessage ?? 'Error loading track',
              );
            }
            final details = state.details;
            if (details == null) {
              return const StatusMessage(message: 'Track not found');
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  details.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('${details.artistName} • ${details.albumTitle}'),
                const SizedBox(height: 8),
                Text('Duration: ${details.duration}s'),
                const SizedBox(height: 8),
                Text('Release: ${details.releaseDate}'),
                if (details.previewUrl.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Preview: ${details.previewUrl}'),
                ],
                if (details.link.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Link: ${details.link}'),
                ],
                const Divider(height: 32),
                Text(
                  'Lyrics',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (state.lyricsStatus == LyricsStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else if (state.lyricsStatus == LyricsStatus.failure)
                  StatusMessage(
                    message: state.lyricsErrorMessage ??
                        'NO INTERNET CONNECTION',
                  )
                else if (state.lyricsStatus == LyricsStatus.empty)
                  const StatusMessage(message: 'Lyrics unavailable')
                else
                  Text(
                    state.lyrics?.lyrics.isNotEmpty == true
                        ? state.lyrics!.lyrics
                        : state.lyrics?.syncedLyrics ?? 'Lyrics unavailable',
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
