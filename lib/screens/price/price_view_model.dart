import '../../models/entity.dart';
import '../../repo/entity_repo.dart';

class PriceViewModel {
  final EntityRepo _repo;

  PriceViewModel(this._repo);

  Stream<List<Item>> getDiscounted() => _repo
      .getDiscounted()
      .first
      .then((items) => getTop10Discounted(items))
      .asStream();

  Stream<String> updatePrice(int id, double price) => _repo.updatePrice(id, price);

  List<Item> getTop10Discounted(List<Item> entities) {
    entities.sort((p1, p2) {
      if (p1.price != null && p2.price != null && p1.price! > p2.price!) {
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
}
