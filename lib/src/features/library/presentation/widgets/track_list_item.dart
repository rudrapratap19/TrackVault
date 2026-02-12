import 'package:flutter/material.dart';

import '../../domain/entities/track_entity.dart';

class TrackListItem extends StatelessWidget {
  const TrackListItem({
    super.key,
    required this.track,
    required this.onTap,
  });

  final TrackEntity track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(track.title),
      subtitle: Text('${track.artistName} • ${track.albumTitle}'),
      trailing: Text('#${track.id}'),
      onTap: onTap,
      dense: true,
    );
  }
}
