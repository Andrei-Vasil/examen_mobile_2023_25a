import 'package:floor/floor.dart';
import 'package:my_albums_flutter/models/entity.dart';

@dao
abstract class EntityDao {
  @Query('SELECT * FROM Item')
  Future<List<Item>> findAllEntities();

  @Query('SELECT * FROM Item WHERE id = :id')
  Future<Item?> findEntityById(String id);

  @Query('DELETE FROM Item')
  Future<void> deleteAllEntities();

  @insert
  Future<void> insertEntity(Item entity);

  @delete
  Future<void> deleteEntity(Item entity);

  @update
  Future<void> updateEntity(Item entity);
}