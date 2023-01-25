import 'package:floor/floor.dart';
import 'package:my_albums_flutter/models/entity.dart';

@dao
abstract class EntityDao {
  @Query('SELECT * FROM Item WHERE category = :category')
  Future<List<Item>> getItemsForCategory(String category);

  @Query('SELECT * FROM Item')
  Future<List<Item>> getDiscounted();

  @Query('DELETE FROM Item')
  Future<void> deleteAllEntities();

  @insert
  Future<void> addItem(Item entity);

  @delete
  Future<void> deleteEntity(Item entity);

  @update
  Future<void> updateEntity(Item entity);

  @Query('SELECT DISTINCT category FROM Item')
  Future<List<String>> getCategories();
}