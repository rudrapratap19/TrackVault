import 'package:flutter/material.dart';

import '../bloc/library_state.dart';

class LibrarySearchBar extends StatelessWidget {
  const LibrarySearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onGroupChanged,
    required this.groupBy,
  });

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<GroupBy> onGroupChanged;
  final GroupBy groupBy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Search tracks or artists',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          DropdownButton<GroupBy>(
            value: groupBy,
            onChanged: (value) {
              if (value != null) {
                onGroupChanged(value);
              }
            },
            items: const [
              DropdownMenuItem(
                value: GroupBy.track,
                child: Text('Track A-Z'),
              ),
              DropdownMenuItem(
                value: GroupBy.artist,
                child: Text('Artist A-Z'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
