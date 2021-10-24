import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  late Widget child;

  Refresh({required this.child});

  Widget build(context) {
    final storiesBloc = StoriesProvider.of(context);
    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await storiesBloc.clearCache();
        await storiesBloc.fetchTopIds();
      },
    );
  }
}
