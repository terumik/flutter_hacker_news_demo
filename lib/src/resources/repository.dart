import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/news_api_provider.dart';
import 'package:news/src/resources/news_db_provider.dart';

// without abstract class
// class Repository {
//   NewsDbProvider dbProvider = NewsDbProvider();
//   NewsApiProvider apiProvider = NewsApiProvider();

//   Future<List<int>> fetchTopIds() {
//     return apiProvider.fetchTopIds();
//   }

//   Future<ItemModel> fetchItem(int id) async {
//     var item = await dbProvider
//         .fetchItem(id); // try to find the item from local storage
//     if (item != null) {
//       return item;
//     }

//     // if no stored item, get item from server then store it locally
//     item = await apiProvider.fetchItem(id);
//     dbProvider.addItem(item);

//     return item;
//   }
// }

class Repository {
  List<Source> sources = <Source>[
    myNewsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    myNewsDbProvider,
  ];

// todo: iterate over sources when dbprovider get fetchTopIds implemented
  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel?> fetchItem(int id) async {
    ItemModel? item;

    for (var source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (item != null) {
        cache.addItem(item);
      }
    }
    return item;
  }

  Future<int?> clearCache() async {
    for (var cache in caches) {
      await cache.clearDb();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clearDb();
}
