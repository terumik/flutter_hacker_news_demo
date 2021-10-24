import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc.dart';
export 'stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  late final StoriesBloc storiesBloc;

  StoriesProvider({
     Key? key,
     required Widget child,
  })  : storiesBloc = StoriesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static StoriesBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoriesProvider>()
            as StoriesProvider)
        .storiesBloc;
  }
}
