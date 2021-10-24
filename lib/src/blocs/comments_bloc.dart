import 'dart:async';

import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Sink getter
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  // Streams getter
  Observable<Map<int, Future<ItemModel>>> get itemWithComments$ =>
      _commentsOutput.stream;

  CommentsBloc() {
    // take the fetcher, transform the stream, pipe it to the output
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int newsId, index) {
        print({'newsId', newsId});
        print({'_commentsTransformer', index});
        // reccursive fetch
        cache[newsId] = _repository.fetchItem(newsId)
            as Future<ItemModel>; // get an ItemModel data
        cache[newsId]!.then((ItemModel item) {
          item.kids.forEach((commentId) {
            print({'commentId', commentId});
            return fetchItemWithComments(commentId);
          });
        });

        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }
}
