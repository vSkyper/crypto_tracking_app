// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class FavoriteCoinsDatabase extends _FavoriteCoinsDatabase
    with RealmEntity, RealmObjectBase, RealmObject {
  FavoriteCoinsDatabase(
    String id,
  ) {
    RealmObjectBase.set(this, 'id', id);
  }

  FavoriteCoinsDatabase._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  Stream<RealmObjectChanges<FavoriteCoinsDatabase>> get changes =>
      RealmObjectBase.getChanges<FavoriteCoinsDatabase>(this);

  @override
  FavoriteCoinsDatabase freeze() =>
      RealmObjectBase.freezeObject<FavoriteCoinsDatabase>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(FavoriteCoinsDatabase._);
    return const SchemaObject(ObjectType.realmObject, FavoriteCoinsDatabase,
        'FavoriteCoinsDatabase', [
      SchemaProperty('id', RealmPropertyType.string),
    ]);
  }
}
