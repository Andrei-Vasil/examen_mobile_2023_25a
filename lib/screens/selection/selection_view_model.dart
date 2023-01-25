import 'package:my_albums_flutter/repo/shared_pref_repo.dart';

import '../../models/entity.dart';
import '../../repo/entity_repo.dart';

class SelectionViewModel {
  final EntityRepo _repo;
  final SharedPrefsRepo _spRepo;

  SelectionViewModel(this._repo, this._spRepo);

  Stream<List<Item>> getEntities() => _repo.getEntities();

  Stream<List<Item>> getAvailableGames() => _repo.getAvailableGames();

  Stream<String?> getUserName() => _spRepo.getUserName();

  Stream<Item> borrowGame(int gameId, String userName) =>
      _repo.borrowGame(gameId, userName);

  Stream<String> deleteEntity(int id) => _repo.deleteEntity(id);
}
