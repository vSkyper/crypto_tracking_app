// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class FavoriteCoinsDatabase extends _FavoriteCoinsDatabase
    with RealmEntity, RealmObject {
  FavoriteCoinsDatabase(
    String id,
  ) {
    RealmObject.set(this, 'id', id);
  }

  FavoriteCoinsDatabase._();

  @override
  String get id => RealmObject.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObject.set(this, 'id', value);

  @override
  Stream<RealmObjectChanges<FavoriteCoinsDatabase>> get changes =>
      RealmObject.getChanges<FavoriteCoinsDatabase>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(FavoriteCoinsDatabase._);
    return const SchemaObject(FavoriteCoinsDatabase, 'FavoriteCoinsDatabase', [
      SchemaProperty('id', RealmPropertyType.string),
    ]);
  }
}
