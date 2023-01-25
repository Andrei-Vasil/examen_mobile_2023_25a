import 'package:my_albums_flutter/repo/entity_repo.dart';
import '../../models/entity.dart';

class MainViewModel {
  final EntityRepo _repo;

  MainViewModel(this._repo);

  Stream<List<String?>> getCategories() => _repo.getCategories();
  Stream<List<Item>> getItemsForCategory(String category) => _repo.getItemsForCategory(category);
  Stream<String?> deleteItem(int id) => _repo.deleteItem(id);
}
