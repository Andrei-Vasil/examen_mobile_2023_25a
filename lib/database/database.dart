// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:my_albums_flutter/DAOs/entity_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/entity.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Item])
abstract class AppDatabase extends FloorDatabase {
  EntityDao get entityDao;
}
