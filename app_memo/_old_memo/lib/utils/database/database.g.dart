// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

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

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

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
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
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
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AccountDao _accountDaoInstance;

  CategoryDao _categoryDaoInstance;

  MemoDao _memoDaoInstance;

  MemoAccountAssociationDao _memoAccountAssociationDaoInstance;

  MemoTagAssociationDao _memoTagAssociationDaoInstance;

  TagDao _tagDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
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
            'CREATE TABLE IF NOT EXISTS `FloorAccount` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `surname` TEXT, `email` TEXT, `registrationDate` TEXT, `lastAccessDate` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FloorCategory` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `description` TEXT, `creationDate` TEXT, `lastModifiedDate` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FloorMemo` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `isOwner` INTEGER, `permission` INTEGER, `title` TEXT, `color` TEXT, `body` TEXT, `creationDate` TEXT, `lastModifiedDate` TEXT, `categoryId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FloorMemoAccountAssociation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `memoId` INTEGER, `accountId` INTEGER, `isOwner` INTEGER, `permission` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FloorMemoTagAssociation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `memoId` INTEGER, `tagId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FloorTag` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `description` TEXT, `creationDate` TEXT, `lastModifiedDate` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AccountDao get accountDao {
    return _accountDaoInstance ??= _$AccountDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  MemoDao get memoDao {
    return _memoDaoInstance ??= _$MemoDao(database, changeListener);
  }

  @override
  MemoAccountAssociationDao get memoAccountAssociationDao {
    return _memoAccountAssociationDaoInstance ??=
        _$MemoAccountAssociationDao(database, changeListener);
  }

  @override
  MemoTagAssociationDao get memoTagAssociationDao {
    return _memoTagAssociationDaoInstance ??=
        _$MemoTagAssociationDao(database, changeListener);
  }

  @override
  TagDao get tagDao {
    return _tagDaoInstance ??= _$TagDao(database, changeListener);
  }
}

class _$AccountDao extends AccountDao {
  _$AccountDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorAccountInsertionAdapter = InsertionAdapter(
            database,
            'FloorAccount',
            (FloorAccount item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'surname': item.surname,
                  'email': item.email,
                  'registrationDate': item.registrationDate,
                  'lastAccessDate': item.lastAccessDate
                }),
        _floorAccountUpdateAdapter = UpdateAdapter(
            database,
            'FloorAccount',
            ['id'],
            (FloorAccount item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'surname': item.surname,
                  'email': item.email,
                  'registrationDate': item.registrationDate,
                  'lastAccessDate': item.lastAccessDate
                }),
        _floorAccountDeletionAdapter = DeletionAdapter(
            database,
            'FloorAccount',
            ['id'],
            (FloorAccount item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'surname': item.surname,
                  'email': item.email,
                  'registrationDate': item.registrationDate,
                  'lastAccessDate': item.lastAccessDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorAccount> _floorAccountInsertionAdapter;

  final UpdateAdapter<FloorAccount> _floorAccountUpdateAdapter;

  final DeletionAdapter<FloorAccount> _floorAccountDeletionAdapter;

  @override
  Future<List<FloorAccount>> findAllAccount() async {
    return _queryAdapter.queryList('SELECT * FROM Account',
        mapper: (Map<String, dynamic> row) => FloorAccount(
            row['id'] as int,
            row['name'] as String,
            row['surname'] as String,
            row['email'] as String,
            row['registrationDate'] as String,
            row['lastAccessDate'] as String));
  }

  @override
  Future<List<FloorAccount>> findAccountById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Account WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => FloorAccount(
            row['id'] as int,
            row['name'] as String,
            row['surname'] as String,
            row['email'] as String,
            row['registrationDate'] as String,
            row['lastAccessDate'] as String));
  }

  @override
  Future<List<FloorAccount>> findAccountByEmail(String email) async {
    return _queryAdapter.queryList('SELECT * FROM Account WHERE email = ?',
        arguments: <dynamic>[email],
        mapper: (Map<String, dynamic> row) => FloorAccount(
            row['id'] as int,
            row['name'] as String,
            row['surname'] as String,
            row['email'] as String,
            row['registrationDate'] as String,
            row['lastAccessDate'] as String));
  }

  @override
  Future<void> insertAccount(FloorAccount account) async {
    await _floorAccountInsertionAdapter.insert(
        account, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAccount(FloorAccount account) async {
    await _floorAccountUpdateAdapter.update(account, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAccount(FloorAccount account) async {
    await _floorAccountDeletionAdapter.delete(account);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorCategoryInsertionAdapter = InsertionAdapter(
            database,
            'FloorCategory',
            (FloorCategory item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'creationDate': item.creationDate,
                  'lastModifiedDate': item.lastModifiedDate
                }),
        _floorCategoryUpdateAdapter = UpdateAdapter(
            database,
            'FloorCategory',
            ['id'],
            (FloorCategory item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'creationDate': item.creationDate,
                  'lastModifiedDate': item.lastModifiedDate
                }),
        _floorCategoryDeletionAdapter = DeletionAdapter(
            database,
            'FloorCategory',
            ['id'],
            (FloorCategory item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'creationDate': item.creationDate,
                  'lastModifiedDate': item.lastModifiedDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorCategory> _floorCategoryInsertionAdapter;

  final UpdateAdapter<FloorCategory> _floorCategoryUpdateAdapter;

  final DeletionAdapter<FloorCategory> _floorCategoryDeletionAdapter;

  @override
  Future<List<FloorCategory>> findAllCategory() async {
    return _queryAdapter.queryList('SELECT * FROM Category',
        mapper: (Map<String, dynamic> row) => FloorCategory(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String));
  }

  @override
  Future<List<FloorCategory>> findAllCategoryById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Category WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => FloorCategory(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String));
  }

  @override
  Future<List<FloorCategory>> findAllCategoryByEmail(String email) async {
    return _queryAdapter.queryList('SELECT * FROM Category WHERE email = ?',
        arguments: <dynamic>[email],
        mapper: (Map<String, dynamic> row) => FloorCategory(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String));
  }

  @override
  Future<void> insertCategory(FloorCategory category) async {
    await _floorCategoryInsertionAdapter.insert(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCategory(FloorCategory category) async {
    await _floorCategoryUpdateAdapter.update(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCategory(FloorCategory category) async {
    await _floorCategoryDeletionAdapter.delete(category);
  }
}

class _$MemoDao extends MemoDao {
  _$MemoDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorMemoInsertionAdapter = InsertionAdapter(
            database,
            'FloorMemo',
            (FloorMemo item) => <String, dynamic>{
                  'id': item.id,
                  'isOwner':
                      item.isOwner == null ? null : (item.isOwner ? 1 : 0),
                  'permission': item.permission,
                  'title': item.title,
                  'color': item.color,
                  'body': item.body,
                  'creationDate': item.creationDate,
                  'lastModifiedDate': item.lastModifiedDate,
                  'categoryId': item.categoryId
                }),
        _floorMemoUpdateAdapter = UpdateAdapter(
            database,
            'FloorMemo',
            ['id'],
            (FloorMemo item) => <String, dynamic>{
                  'id': item.id,
                  'isOwner':
                      item.isOwner == null ? null : (item.isOwner ? 1 : 0),
                  'permission': item.permission,
                  'title': item.title,
                  'color': item.color,
                  'body': item.body,
                  'creationDate': item.creationDate,
                  'lastModifiedDate': item.lastModifiedDate,
                  'categoryId': item.categoryId
                }),
        _floorMemoDeletionAdapter = DeletionAdapter(
            database,
            'FloorMemo',
            ['id'],
            (FloorMemo item) => <String, dynamic>{
                  'id': item.id,
                  'isOwner':
                      item.isOwner == null ? null : (item.isOwner ? 1 : 0),
                  'permission': item.permission,
                  'title': item.title,
                  'color': item.color,
                  'body': item.body,
                  'creationDate': item.creationDate,
                  'lastModifiedDate': item.lastModifiedDate,
                  'categoryId': item.categoryId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorMemo> _floorMemoInsertionAdapter;

  final UpdateAdapter<FloorMemo> _floorMemoUpdateAdapter;

  final DeletionAdapter<FloorMemo> _floorMemoDeletionAdapter;

  @override
  Future<List<FloorMemo>> findAllMemo() async {
    return _queryAdapter.queryList('SELECT * FROM Memo',
        mapper: (Map<String, dynamic> row) => FloorMemo(
            id: row['id'] as int,
            isOwner:
                row['isOwner'] == null ? null : (row['isOwner'] as int) != 0,
            permission: row['permission'] as int,
            title: row['title'] as String,
            color: row['color'] as String,
            body: row['body'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String,
            categoryId: row['categoryId'] as int));
  }

  @override
  Future<FloorMemo> findMemoById(int id) async {
    return _queryAdapter.query('SELECT * FROM Memo WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => FloorMemo(
            id: row['id'] as int,
            isOwner:
                row['isOwner'] == null ? null : (row['isOwner'] as int) != 0,
            permission: row['permission'] as int,
            title: row['title'] as String,
            color: row['color'] as String,
            body: row['body'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String,
            categoryId: row['categoryId'] as int));
  }

  @override
  Future<FloorMemo> findMemoByTitle(String title) async {
    return _queryAdapter.query('SELECT * FROM Memo WHERE title = ?',
        arguments: <dynamic>[title],
        mapper: (Map<String, dynamic> row) => FloorMemo(
            id: row['id'] as int,
            isOwner:
                row['isOwner'] == null ? null : (row['isOwner'] as int) != 0,
            permission: row['permission'] as int,
            title: row['title'] as String,
            color: row['color'] as String,
            body: row['body'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String,
            categoryId: row['categoryId'] as int));
  }

  @override
  Future<FloorMemo> findMemoByCategoryId(int categoryId) async {
    return _queryAdapter.query('SELECT * FROM Memo WHERE categoryId = ?',
        arguments: <dynamic>[categoryId],
        mapper: (Map<String, dynamic> row) => FloorMemo(
            id: row['id'] as int,
            isOwner:
                row['isOwner'] == null ? null : (row['isOwner'] as int) != 0,
            permission: row['permission'] as int,
            title: row['title'] as String,
            color: row['color'] as String,
            body: row['body'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String,
            categoryId: row['categoryId'] as int));
  }

  @override
  Future<void> insertMemo(FloorMemo memo) async {
    await _floorMemoInsertionAdapter.insert(memo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMemo(FloorMemo memo) async {
    await _floorMemoUpdateAdapter.update(memo, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMemo(FloorMemo memo) async {
    await _floorMemoDeletionAdapter.delete(memo);
  }
}

class _$MemoAccountAssociationDao extends MemoAccountAssociationDao {
  _$MemoAccountAssociationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorMemoAccountAssociationInsertionAdapter = InsertionAdapter(
            database,
            'FloorMemoAccountAssociation',
            (FloorMemoAccountAssociation item) => <String, dynamic>{
                  'id': item.id,
                  'memoId': item.memoId,
                  'accountId': item.accountId,
                  'isOwner':
                      item.isOwner == null ? null : (item.isOwner ? 1 : 0),
                  'permission': item.permission
                }),
        _floorMemoAccountAssociationUpdateAdapter = UpdateAdapter(
            database,
            'FloorMemoAccountAssociation',
            ['id'],
            (FloorMemoAccountAssociation item) => <String, dynamic>{
                  'id': item.id,
                  'memoId': item.memoId,
                  'accountId': item.accountId,
                  'isOwner':
                      item.isOwner == null ? null : (item.isOwner ? 1 : 0),
                  'permission': item.permission
                }),
        _floorMemoAccountAssociationDeletionAdapter = DeletionAdapter(
            database,
            'FloorMemoAccountAssociation',
            ['id'],
            (FloorMemoAccountAssociation item) => <String, dynamic>{
                  'id': item.id,
                  'memoId': item.memoId,
                  'accountId': item.accountId,
                  'isOwner':
                      item.isOwner == null ? null : (item.isOwner ? 1 : 0),
                  'permission': item.permission
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorMemoAccountAssociation>
      _floorMemoAccountAssociationInsertionAdapter;

  final UpdateAdapter<FloorMemoAccountAssociation>
      _floorMemoAccountAssociationUpdateAdapter;

  final DeletionAdapter<FloorMemoAccountAssociation>
      _floorMemoAccountAssociationDeletionAdapter;

  @override
  Future<FloorMemoAccountAssociation> findMemoAccountAssociationByAccountId(
      int accountId) async {
    return _queryAdapter.query('SELECT * FROM Memo WHERE accountId = ?',
        arguments: <dynamic>[accountId],
        mapper: (Map<String, dynamic> row) => FloorMemoAccountAssociation(
            row['id'] as int,
            row['memoId'] as int,
            row['accountId'] as int,
            row['isOwner'] == null ? null : (row['isOwner'] as int) != 0,
            row['permission'] as int));
  }

  @override
  Future<FloorMemoAccountAssociation> findMemoAccountAssociationByMemoId(
      int memoId) async {
    return _queryAdapter.query('SELECT * FROM Memo WHERE memoId = ?',
        arguments: <dynamic>[memoId],
        mapper: (Map<String, dynamic> row) => FloorMemoAccountAssociation(
            row['id'] as int,
            row['memoId'] as int,
            row['accountId'] as int,
            row['isOwner'] == null ? null : (row['isOwner'] as int) != 0,
            row['permission'] as int));
  }

  @override
  Future<void> insertMemoAccountAssociation(
      FloorMemoAccountAssociation memoAccountAssociation) async {
    await _floorMemoAccountAssociationInsertionAdapter.insert(
        memoAccountAssociation, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMemoAccountAssociation(
      FloorMemoAccountAssociation memoAccountAssociation) async {
    await _floorMemoAccountAssociationUpdateAdapter.update(
        memoAccountAssociation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMemoAccountAssociation(
      FloorMemoAccountAssociation memoAccountAssociation) async {
    await _floorMemoAccountAssociationDeletionAdapter
        .delete(memoAccountAssociation);
  }
}

class _$MemoTagAssociationDao extends MemoTagAssociationDao {
  _$MemoTagAssociationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorMemoTagAssociationInsertionAdapter = InsertionAdapter(
            database,
            'FloorMemoTagAssociation',
            (FloorMemoTagAssociation item) => <String, dynamic>{
                  'id': item.id,
                  'memoId': item.memoId,
                  'tagId': item.tagId
                }),
        _floorMemoTagAssociationUpdateAdapter = UpdateAdapter(
            database,
            'FloorMemoTagAssociation',
            ['id'],
            (FloorMemoTagAssociation item) => <String, dynamic>{
                  'id': item.id,
                  'memoId': item.memoId,
                  'tagId': item.tagId
                }),
        _floorMemoTagAssociationDeletionAdapter = DeletionAdapter(
            database,
            'FloorMemoTagAssociation',
            ['id'],
            (FloorMemoTagAssociation item) => <String, dynamic>{
                  'id': item.id,
                  'memoId': item.memoId,
                  'tagId': item.tagId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorMemoTagAssociation>
      _floorMemoTagAssociationInsertionAdapter;

  final UpdateAdapter<FloorMemoTagAssociation>
      _floorMemoTagAssociationUpdateAdapter;

  final DeletionAdapter<FloorMemoTagAssociation>
      _floorMemoTagAssociationDeletionAdapter;

  @override
  Future<FloorMemoTagAssociation> findTagByMemoId(int memoId) async {
    return _queryAdapter.query(
        'SELECT * FROM MemoTagAssociation WHERE memoId = ?',
        arguments: <dynamic>[memoId],
        mapper: (Map<String, dynamic> row) => FloorMemoTagAssociation(
            row['id'] as int, row['memoId'] as int, row['tagId'] as int));
  }

  @override
  Future<FloorMemoTagAssociation> findTagByTagId(int tagId) async {
    return _queryAdapter.query('SELECT * FROM Tag WHERE tagId = ?',
        arguments: <dynamic>[tagId],
        mapper: (Map<String, dynamic> row) => FloorMemoTagAssociation(
            row['id'] as int, row['memoId'] as int, row['tagId'] as int));
  }

  @override
  Future<void> insertMemoAccountAssociation(
      FloorMemoTagAssociation memoTagAssociation) async {
    await _floorMemoTagAssociationInsertionAdapter.insert(
        memoTagAssociation, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMemoAccountAssociation(
      FloorMemoTagAssociation memoTagAssociation) async {
    await _floorMemoTagAssociationUpdateAdapter.update(
        memoTagAssociation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMemoAccountAssociation(
      FloorMemoTagAssociation memoTagAssociation) async {
    await _floorMemoTagAssociationDeletionAdapter.delete(memoTagAssociation);
  }
}

class _$TagDao extends TagDao {
  _$TagDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorTagInsertionAdapter = InsertionAdapter(
            database,
            'FloorTag',
            (FloorTag item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'creationDate': item.creationDate,
                  'lastModifiedDate': item.lastModifiedDate
                }),
        _floorTagUpdateAdapter = UpdateAdapter(
            database,
            'FloorTag',
            ['id'],
            (FloorTag item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'creationDate': item.creationDate,
                  'lastModifiedDate': item.lastModifiedDate
                }),
        _floorTagDeletionAdapter = DeletionAdapter(
            database,
            'FloorTag',
            ['id'],
            (FloorTag item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'creationDate': item.creationDate,
                  'lastModifiedDate': item.lastModifiedDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorTag> _floorTagInsertionAdapter;

  final UpdateAdapter<FloorTag> _floorTagUpdateAdapter;

  final DeletionAdapter<FloorTag> _floorTagDeletionAdapter;

  @override
  Future<List<FloorTag>> findAllTag() async {
    return _queryAdapter.queryList('SELECT * FROM Tag',
        mapper: (Map<String, dynamic> row) => FloorTag(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String));
  }

  @override
  Future<FloorTag> findTagById(int id) async {
    return _queryAdapter.query('SELECT * FROM Tag WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => FloorTag(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String));
  }

  @override
  Future<FloorTag> findTagByAccountId(int accountId) async {
    return _queryAdapter.query('SELECT * FROM Tag WHERE accountId = ?',
        arguments: <dynamic>[accountId],
        mapper: (Map<String, dynamic> row) => FloorTag(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String));
  }

  @override
  Future<FloorTag> findTagByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Tag WHERE name = ?',
        arguments: <dynamic>[name],
        mapper: (Map<String, dynamic> row) => FloorTag(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            creationDate: row['creationDate'] as String,
            lastModifiedDate: row['lastModifiedDate'] as String));
  }

  @override
  Future<void> insertTag(FloorTag tag) async {
    await _floorTagInsertionAdapter.insert(tag, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTag(FloorTag tag) async {
    await _floorTagUpdateAdapter.update(tag, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTag(FloorTag tag) async {
    await _floorTagDeletionAdapter.delete(tag);
  }
}
