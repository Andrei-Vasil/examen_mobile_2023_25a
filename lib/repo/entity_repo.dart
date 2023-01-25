import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../DAOs/entity_dao.dart';
import '../models/entity.dart';
import '../networking/rest_client.dart';

class EntityRepo {
  static bool useLocal = false;
  static bool hasInternet = true;
  static late final Logger logger;

  static late final EntityDao entityDao;
  static late final RestClient client;

  Stream<String> addEntity(Item entity) {
    if (hasInternet) {
      return client
          .postEntity(entity)
          .asStream()
          .flatMap((_) => Stream.value("ok"))
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    } else {
      entity.id = DateTime.now().millisecondsSinceEpoch;
      return entityDao
          .insertEntity(entity)
          .asStream()
          .flatMap((_) => Stream.value("ok"))
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
  }

  Stream<String> deleteEntity(int id) {
    /// Database version:
    // return entityDao
    //     .findEntityById(id)
    //     .asStream()
    //     .flatMap((entity) => entity != null
    //         ? entityDao
    //             .deleteEntity(entity)
    //             .asStream()
    //             .flatMap((_) => Stream.value("ok"))
    //         : Stream.value("The entity does not exist !"))
    //     .onErrorResume((error, stackTrace) => Stream.error(error.toString()));

    return client
        .deleteEntity(id)
        .asStream()
        .flatMap((_) => Stream.value("ok"))
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<String> updateEntity(Item entity) {
    /// Database version:
    // return entityDao
    //     .updateEntity(entity)
    //     .asStream()
    //     .flatMap((_) => Stream.value("ok"))
    //     .onErrorResume((error, stackTrace) => Stream.error(error.toString()));

    return client
        .putEntity(entity.id ?? 0, entity)
        .asStream()
        .flatMap((_) => Stream.value("ok"))
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<List<Item>> getEntities() {
    /// Database version:
    // return entityDao
    //     .findAllEntities()
    //     .asStream()
    //     .onErrorResume((error, stackTrace) => Stream.error(error.toString()));

    return client
        .getItems()
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<List<String>> getEntityTypes() {
    /// mocked version:
    // return Stream.value(["manufacturer1", "manufacturer2"]);

    return client
        .getTypes()
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<List<Item>> getEntitiesForType(String type) {
    /// mocked version:
    //return getEntities();

    return client
        .getEntitiesForType(type)
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<List<Item>> getEntitiesForUser(String user) {
    if (!useLocal) {
      return client.getEntitiesForUser(user).asStream().flatMap((games) {
        return entityDao
            .findAllEntities()
            .asStream()
            .asyncMap((entities) async {
          // Delete all entities from local storage
          await entityDao.deleteAllEntities();

          // Insert all entities from server into local storage
          for (var game in games) {
            entityDao.insertEntity(game);
          }

          // return the server entities
          return games;
        });
      }).onErrorResume((error, stackTrace) => Stream.value([]));
    } else {
      return entityDao
          .findAllEntities()
          .asStream()
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
  }

  Stream<List<Item>> getAvailableGames() {
    return client
        .getAvailableEntities()
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<Item> borrowGame(int gameId, String userName) {
    return client
        .borrowGame(<String, dynamic>{
          'id': gameId,
          'main': userName,
        })
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }
}
