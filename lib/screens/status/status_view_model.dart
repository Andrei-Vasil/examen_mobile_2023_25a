import '../../../models/entity.dart';
import '../../../repo/entity_repo.dart';

class StatusViewModel {
  final EntityRepo _repo;

  StatusViewModel(this._repo);

  Stream<List<Item>> getEntities() => _repo.getEntities();

  List<Item> getTop10MostPopularGames(List<Item> entities) {
    entities.sort((p1, p2) {
      if (p1.price != null &&
          p2.price != null &&
          p1.price! > p2.price!) {
        return -1;
      } else if (p1.price != null &&
          p2.price != null &&
          p1.price! < p2.price!) {
        return 1;
      } else {
        return 0;
      }
    });
    return entities.take(10).toList();
  }

  List<Owner> getTop10Owners(List<Item> entities) {
    entities.sort((p1, p2) {
      var owner1NrOfPlanes =
          entities.where((element) => p1.category == element.category).length;
      var owner2NrOfPlanes =
          entities.where((element) => p2.category == element.category).length;
      if (owner1NrOfPlanes < owner2NrOfPlanes) {
        return -1;
      } else if (owner1NrOfPlanes > owner2NrOfPlanes) {
        return 1;
      } else {
        return 0;
      }
    });
    return entities
        .map((e) => Owner(
            e.category ?? "",
            entities
                .where((element) => e.category == element.category)
                .length
                .toString()))
        .toList()
        .toSet()
        .take(10)
        .toList();
  }

  List<Item> getTop5PlanesByCapacity(List<Item> entities) {
    entities.sort((p1, p2) {
      if (p1.price != null &&
          p2.price != null &&
          p1.price! > p2.price!) {
        return -1;
      } else if (p1.price != null &&
          p2.price != null &&
          p1.price! < p2.price!) {
        return 1;
      } else {
        return 0;
      }
    });

    return entities.take(5).toList();
  }
}

class Owner {
  final String name;
  final String nrOfPlanes;

  Owner(this.name, this.nrOfPlanes);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Owner && name == other.name && nrOfPlanes == other.nrOfPlanes;

  @override
  int get hashCode => name.hashCode ^ nrOfPlanes.hashCode;
}
