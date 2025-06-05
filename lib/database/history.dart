import 'package:isar/isar.dart';

part 'history.g.dart';

@Collection()
class History {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String url;
  
  @Index()
  late String rawText;

  late DateTime timestamp;

  History();

  History.fromUrl(this.url) {
    timestamp = DateTime.now();
  }

  @override
  String toString() {
    return 'History{id: $id, url: $url, timestamp: $timestamp}';
  }
}
