import 'package:realm/realm.dart';
part 'app.g.dart';

@RealmModel()
class _FavoriteCoinsDatabase {
  late String id;
}

var config = Configuration.local([FavoriteCoinsDatabase.schema]);
var realm = Realm(config);