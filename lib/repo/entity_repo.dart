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

  Future<bool> backup() {
    return client.getDiscounted().asStream().flatMap((entities2) {
      return entityDao.getDiscounted().asStream().asyncMap((entities) async {
        // Delete all entities from local storage
        await entityDao.deleteAllEntities();

        // Insert all entities from server into local storage
        for (var entity in entities2) {
          entityDao.addItem(entity);
        }
        return true;
      });
    }).first;
  }

  Stream<List<String?>> getCategories() {
    if (useLocal) {
      return entityDao
          .getCategories()
          .asStream()
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return backup()
        .then((_) {
          return client.getCategories();
        })
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<List<Item>> getItemsForCategory(String category) {
    if (useLocal) {
      return entityDao
          .getItemsForCategory(category)
          .asStream()
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return client
        .getItemsForCategory(category)
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<List<Item>> getDiscounted() {
    if (useLocal) {
      return entityDao
          .getDiscounted()
          .asStream()
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return backup()
        .then((_) {
          return client.getDiscounted();
        })
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<String> addItem(Item item) {
    if (hasInternet) {
      return client
          .postItem(item)
          .asStream()
          .flatMap((_) => Stream.value("ok"))
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return Stream.error("No internet connection");
  }

  Stream<String> deleteItem(int id) {
    if (hasInternet) {
      return client
          .deleteItem(id)
          .asStream()
          .flatMap((_) => Stream.value("ok"))
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return Stream.error("No internet connection");
  }

  Stream<String> updatePrice(int id, double price) {
    if (hasInternet) {
      return client
          .updatePrice(<String, dynamic>{
            "id": id,
            "price": price,
          })
          .asStream()
          .flatMap((_) => Stream.value("ok"))
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return Stream.error("No internet connection");
  }
}
