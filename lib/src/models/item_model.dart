import 'dart:convert';

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
//  final String poll;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
//  final String parts;
  final int descendants;

// constructor from Json (ref: https://stackoverflow.com/questions/52528818/difference-between-class-constructor-syntax-in-dart)
// "an initializer list (the list of assignments after the :) to initialize the final instance variables"
  ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        deleted = parsedJson['deleted'] ?? false, // if null, assign false
        type = parsedJson['type'],
        by = parsedJson['by'] ?? '',
        time = parsedJson['time'],
        text = parsedJson['text']  ?? '', // if null, assign ''
        dead = parsedJson['dead']  ?? false, // if null, assign false
        parent = parsedJson['parent'],
        kids = parsedJson['kids']  ?? [], // if null, assign []
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'] ?? 0;

  ItemModel.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        deleted = parsedJson['deleted'] == 1,
        type = parsedJson['type'],
        by = parsedJson['by'],
        time = parsedJson['time'],
        text = parsedJson['text'],
        dead = parsedJson['dead'] == 1,
        parent = parsedJson['parent'],
        kids = jsonDecode(parsedJson['kids']),
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'] ?? 0;

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "id": id,
      "type": type,
      "by": by,
      "time": time,
      "text": text,
      "parent": parent,
      "url": url,
      "score": score,
      "title": title,
      "descendants": descendants,
      "deleted": deleted ? 1 : 0,
      "dead": dead ? 1 : 0,
      "kids": jsonEncode(kids),
    };
  }
}
