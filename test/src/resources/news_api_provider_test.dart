import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:news/src/resources/news_api_provider.dart';

void main() {
  test('2 + 3 should return 5', () {
    // set up test case
    final sum = 2 + 3;
    // expectation
    expect(sum, 5);
  }); // => run "flutter test"

  test('FetchTopIds should returns a list of ids', () async {
    // set up test case
    final newsApi = NewsApiProvider();

// if using Client(), test will run MockClient instead of real http request
    newsApi.httpClient = MockClient((req) async {
      return Response(json.encode([1, 2, 3]), 200);
    });
    final ids = await newsApi.fetchTopIds();

    // expectation
    expect(ids, [1, 2, 3]);
  }); // => run "flutter test" (or flutter test --no-sound-null-safety)


  test('FetchItem should return a ItemModel', () async {
    final newsApi = NewsApiProvider();
    newsApi.httpClient = MockClient((req) async {
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    } );

    final item = await newsApi.fetchItem(999);

    // expectation
    expect(item.id, 123);
  });


}
