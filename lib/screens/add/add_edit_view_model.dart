import '../../../models/entity.dart';
import '../../../repo/entity_repo.dart';

class AddEditViewModel {
  final EntityRepo _repo;

  AddEditViewModel(this._repo);

  Stream<String> addEntity(Item item) => _repo.addItem(item);

  Stream<String> updateEntity(Item item) =>
      Stream.error("functionality not implemented");
}
