import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import 'package:flutter_html/flutter_html.dart';

import 'loading_list_tile_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({required this.itemId, required this.itemMap, required this.depth});

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
        if (!snapshot.hasData) {
          return LoadingListTileContainer();
        }

        final children = <Widget>[
          ListTile(
            title: Html(
              data: snapshot.data!.text,
            ),
            subtitle: snapshot.data!.by == ''
                ? Text('Comment Deleted')
                : Text(snapshot.data!.by),
            contentPadding: EdgeInsets.only(
              left: depth * 16,
              right: 16,
            ),
          ),
          Divider(),
        ];

        snapshot.data!.kids.forEach((kidId) {
          children.add(
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );
        });
        return Column(
          children: children,
        );
      },
    );
  }

  buildText(ItemModel? data) {}
}
