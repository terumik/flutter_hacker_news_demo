import 'package:flutter/cupertino.dart';
import 'package:news/src/blocs/comments_bloc.dart';

class CommentsProvider extends InheritedWidget {
  late final CommentsBloc commentsBloc;

  CommentsProvider({
    Key? key,
    required Widget child,
  })  : commentsBloc = CommentsBloc(),
        super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static CommentsBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CommentsProvider>()
            as CommentsProvider)
        .commentsBloc;
  }
}
