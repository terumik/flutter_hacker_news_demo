import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/screens/news_detail.dart';
import 'package:news/src/screens/news_list.dart';

class MyApp extends StatelessWidget {
  Widget build(context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News List',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    print({'settings.arguments', settings.arguments});
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) {
            final storiesBloc = StoriesProvider.of(context);
            storiesBloc.fetchTopIds();
            return NewsList();
          },
        );
      case '/detail':
        return MaterialPageRoute(
          builder: (context) {
            final newsId = settings.arguments as int;
            final commentBloc = CommentsProvider.of(context);
            commentBloc.fetchItemWithComments(newsId);
            return NewsDetails(newsId: newsId);
          },
        );
      default:
        // todo: show 404
        throw Error();
    }
  }
}
