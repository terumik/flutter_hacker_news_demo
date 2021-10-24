// import only a certain module instead of importing entire module from http
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/repository.dart';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client httpClient = Client();
  Future<List<int>> fetchTopIds() async {
    final res = await httpClient.get('$_root/topstories.json');
    final ids = json.decode(res.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final res = await httpClient.get('$_root/item/$id.json');
    final parsedJson = json.decode(res.body);
    return ItemModel.fromJson(parsedJson);
  }
}
