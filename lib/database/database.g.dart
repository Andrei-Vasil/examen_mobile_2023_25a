// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  EntityDao? _entityDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Item` (`id` INTEGER, `name` TEXT, `description` TEXT, `image` TEXT, `category` TEXT, `units` INTEGER, `price` REAL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EntityDao get entityDao {
    return _entityDaoInstance ??= _$EntityDao(database, changeListener);
  }
}

class _$EntityDao extends EntityDao {
  _$EntityDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _itemInsertionAdapter = InsertionAdapter(
            database,
            'Item',
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'image': item.image,
                  'category': item.category,
                  'units': item.units,
                  'price': item.price
                }),
        _itemUpdateAdapter = UpdateAdapter(
            database,
            'Item',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'image': item.image,
                  'category': item.category,
                  'units': item.units,
                  'price': item.price
                }),
        _itemDeletionAdapter = DeletionAdapter(
            database,
            'Item',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'image': item.image,
                  'category': item.category,
                  'units': item.units,
                  'price': item.price
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Item> _itemInsertionAdapter;

  final UpdateAdapter<Item> _itemUpdateAdapter;

  final DeletionAdapter<Item> _itemDeletionAdapter;

  @override
  Future<List<Item>> getItemsForCategory(String category) async {
    return _queryAdapter.queryList('SELECT * FROM Item WHERE category = ?1',
        mapper: (Map<String, Object?> row) => Item(
            id: row['id'] as int?,
            name: row['name'] as String?,
            description: row['description'] as String?,
            image: row['image'] as String?,
            category: row['category'] as String?,
            units: row['units'] as int?,
            price: row['price'] as double?),
        arguments: [category]);
  }

  @override
  Future<List<Item>> getDiscounted() async {
    return _queryAdapter.queryList('SELECT * FROM Item',
        mapper: (Map<String, Object?> row) => Item(
            id: row['id'] as int?,
            name: row['name'] as String?,
            description: row['description'] as String?,
            image: row['image'] as String?,
            category: row['category'] as String?,
            units: row['units'] as int?,
            price: row['price'] as double?));
  }

  @override
  Future<void> deleteAllEntities() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Item');
  }

  @override
  Future<List<String>> getCategories() async {
    return _queryAdapter.queryList('SELECT DISTINCT category FROM Item',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<void> addItem(Item entity) async {
    await _itemInsertionAdapter.insert(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEntity(Item entity) async {
    await _itemUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(Item entity) async {
    await _itemDeletionAdapter.delete(entity);
  }
}
