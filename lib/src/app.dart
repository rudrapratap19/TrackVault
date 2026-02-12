import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/api_client.dart';
import 'features/library/data/datasources/deezer_remote_data_source.dart';
import 'features/library/data/repositories/track_repository_impl.dart';
import 'features/library/presentation/bloc/library_bloc.dart';
import 'features/library/presentation/bloc/library_event.dart';
import 'features/library/presentation/screens/library_screen.dart';
import 'features/track_details/data/datasources/track_details_remote_data_source.dart';
import 'features/track_details/data/repositories/track_details_repository_impl.dart';

class TrackVaultApp extends StatelessWidget {
  const TrackVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final trackRepository = TrackRepositoryImpl(
      DeezerRemoteDataSource(apiClient),
    );
    final trackDetailsRepository = TrackDetailsRepositoryImpl(
      TrackDetailsRemoteDataSource(apiClient),
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: trackRepository),
        RepositoryProvider.value(value: trackDetailsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LibraryBloc(trackRepository)..add(const LibraryStarted()),
          ),
        ],
        child: MaterialApp(
          title: 'TrackVault',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
          ),
          home: const LibraryScreen(),
        ),
      ),
    );
  }
}
