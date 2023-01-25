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

  Stream<List<String?>> getCategories() {
    if (useLocal) {
      return entityDao
          .getCategories()
          .asStream()
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return client
        .getCategories()
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
    return client
        .getDiscounted()
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

  Stream<String> updatePrice(int id) {
    if (hasInternet) {
      return client
          .updatePrice(id)
          .asStream()
          .flatMap((_) => Stream.value("ok"))
          .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return Stream.error("No internet connection");
  }
}
