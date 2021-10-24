import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_bloc.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/comment.dart';

class NewsDetails extends StatelessWidget {
  final int newsId;

  NewsDetails({required this.newsId});

  Widget build(context) {
    final commentBloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: buildBody(commentBloc),
    );
  }

  Widget buildBody(CommentsBloc commentsBloc) {
    return StreamBuilder(
      stream: commentsBloc.itemWithComments$,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading item...');
        }
        print({snapshot.data![newsId]});
        final itemFuture = snapshot.data![newsId];
        return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return buildList(itemSnapshot.data, snapshot.data);
            });
      },
    );
  }

  Widget buildTitle(ItemModel? itemData) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(20),
      child: Text(
        itemData!.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget buildList(ItemModel? item, Map<int, Future<ItemModel>>? itemMap) {
    final commentList = item?.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap!,
        depth: 1, // always top level
      );
    }).toList();
    return ListView(
      children: <Widget>[
        buildTitle(item),
        ...commentList!,
      ],
    );
  }
}
