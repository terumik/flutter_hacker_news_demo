import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/loading_list_tile_container.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({required this.itemId});

  Widget build(context) {
    final storiesBloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: storiesBloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingListTileContainer();
        }

        return FutureBuilder(
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingListTileContainer();
            }
            return buildTile(context, itemSnapshot.data!);
          },
          future: snapshot.data?[itemId],
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: [
        ListTile(
          title: Text(item.title),
          subtitle: Text('Score: ${item.score}'),
          trailing: Column(
            children: [
              Icon(Icons.comment),
              Text(item.descendants.toString()),
            ],
          ),
          onTap: () {
            print({'Tapped the item id', item.id});
            Navigator.pushNamed(context, '/detail', arguments: item.id);
          },
        ),
        Divider(
          height: 8,
        ),
      ],
    );
  }
}
