import '../../../models/entity.dart';
import '../../../repo/entity_repo.dart';

class AddEditViewModel {
  final EntityRepo _repo;

  AddEditViewModel(this._repo);

  Stream<String> addEntity(Item entity) => _repo.addEntity(entity);
  Stream<String> updateEntity(Item entity) => _repo.updateEntity(entity);
}
