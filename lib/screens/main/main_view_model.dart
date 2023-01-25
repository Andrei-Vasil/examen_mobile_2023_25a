import 'package:my_albums_flutter/repo/entity_repo.dart';
import 'package:my_albums_flutter/repo/shared_pref_repo.dart';

import '../../models/entity.dart';

class MainViewModel {
  final SharedPrefsRepo _repo;
  final EntityRepo _entityRepo;

  MainViewModel(this._repo, this._entityRepo);

  Stream<String?> getUserName() => _repo.getUserName();

  Stream<bool> setUserName(String name) => _repo.setUserName(name);

  Stream<List<Item>> getUserGames(String user) =>
      _entityRepo.getEntitiesForUser(user);
}
