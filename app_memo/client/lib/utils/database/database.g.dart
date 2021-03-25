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

  AccountDao? _accountDaoInstance;

  CategoryDao? _categoryInstance;

  MemoDao? _memoInstance;

  MemoAccountAssociationDao? _memoAccountAssociationInstance;

  MemoTagAssociationDao? _memoTagAssociationInstance;

  TagDao? _memoTagInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
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
            'CREATE TABLE IF NOT EXISTS `Account` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `_name` TEXT, `_surname` TEXT, `_email` TEXT, `_registrationDate` TEXT, `_lastAccessDate` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MemoCategory` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `_name` TEXT, `_description` TEXT, `_creationDate` TEXT, `_lastModifiedDate` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Memo` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `_isOwner` INTEGER, `_permission` INTEGER, `_title` TEXT, `_color` TEXT, `_body` TEXT, `_creationDate` TEXT, `_lastModifiedDate` TEXT, `_categoryId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MemoAccountAssociation` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `_memoId` INTEGER, `_accountId` INTEGER, `_isOwner` INTEGER, `_permission` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MemoTagAssociation` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `_memoId` INTEGER, `_tagId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MemoTag` (`_id` INTEGER PRIMARY KEY AUTOINCREMENT, `_name` TEXT, `_description` TEXT, `_creationDate` TEXT, `_lastModifiedDate` TEXT)');

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
  CategoryDao get category {
    return _categoryInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  MemoDao get memo {
    return _memoInstance ??= _$MemoDao(database, changeListener);
  }

  @override
  MemoAccountAssociationDao get memoAccountAssociation {
    return _memoAccountAssociationInstance ??=
        _$MemoAccountAssociationDao(database, changeListener);
  }

  @override
  MemoTagAssociationDao get memoTagAssociation {
    return _memoTagAssociationInstance ??=
        _$MemoTagAssociationDao(database, changeListener);
  }

  @override
  TagDao get memoTag {
    return _memoTagInstance ??= _$TagDao(database, changeListener);
  }
}

class _$AccountDao extends AccountDao {
  _$AccountDao(this.database, this.changeListener)
      : _accountInsertionAdapter = InsertionAdapter(
            database,
            'Account',
            (Account item) => <String, Object?>{
                  '_id': item._id,
                  '_name': item._name,
                  '_surname': item._surname,
                  '_email': item._email,
                  '_registrationDate': item._registrationDate,
                  '_lastAccessDate': item._lastAccessDate
                }),
        _accountUpdateAdapter = UpdateAdapter(
            database,
            'Account',
            ['_id'],
            (Account item) => <String, Object?>{
                  '_id': item._id,
                  '_name': item._name,
                  '_surname': item._surname,
                  '_email': item._email,
                  '_registrationDate': item._registrationDate,
                  '_lastAccessDate': item._lastAccessDate
                }),
        _accountDeletionAdapter = DeletionAdapter(
            database,
            'Account',
            ['_id'],
            (Account item) => <String, Object?>{
                  '_id': item._id,
                  '_name': item._name,
                  '_surname': item._surname,
                  '_email': item._email,
                  '_registrationDate': item._registrationDate,
                  '_lastAccessDate': item._lastAccessDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<Account> _accountInsertionAdapter;

  final UpdateAdapter<Account> _accountUpdateAdapter;

  final DeletionAdapter<Account> _accountDeletionAdapter;

  @override
  Future<void> insertAccount(Account account) async {
    await _accountInsertionAdapter.insert(account, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAccount(Account account) async {
    await _accountUpdateAdapter.update(account, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAccount(Account account) async {
    await _accountDeletionAdapter.delete(account);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _memoCategoryInsertionAdapter = InsertionAdapter(
            database,
            'MemoCategory',
            (MemoCategory item) => <String, Object?>{
                  '_id': item._id,
                  '_name': item._name,
                  '_description': item._description,
                  '_creationDate': item._creationDate,
                  '_lastModifiedDate': item._lastModifiedDate
                }),
        _memoCategoryUpdateAdapter = UpdateAdapter(
            database,
            'MemoCategory',
            ['_id'],
            (MemoCategory item) => <String, Object?>{
                  '_id': item._id,
                  '_name': item._name,
                  '_description': item._description,
                  '_creationDate': item._creationDate,
                  '_lastModifiedDate': item._lastModifiedDate
                }),
        _memoCategoryDeletionAdapter = DeletionAdapter(
            database,
            'MemoCategory',
            ['_id'],
            (MemoCategory item) => <String, Object?>{
                  '_id': item._id,
                  '_name': item._name,
                  '_description': item._description,
                  '_creationDate': item._creationDate,
                  '_lastModifiedDate': item._lastModifiedDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<MemoCategory> _memoCategoryInsertionAdapter;

  final UpdateAdapter<MemoCategory> _memoCategoryUpdateAdapter;

  final DeletionAdapter<MemoCategory> _memoCategoryDeletionAdapter;

  @override
  Future<void> insertCategory(MemoCategory category) async {
    await _memoCategoryInsertionAdapter.insert(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCategory(MemoCategory category) async {
    await _memoCategoryUpdateAdapter.update(category, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCategory(MemoCategory category) async {
    await _memoCategoryDeletionAdapter.delete(category);
  }
}

class _$MemoDao extends MemoDao {
  _$MemoDao(this.database, this.changeListener)
      : _memoInsertionAdapter = InsertionAdapter(
            database,
            'Memo',
            (Memo item) => <String, Object?>{
                  '_id': item._id,
                  '_isOwner':
                      item._isOwner == null ? null : (item._isOwner! ? 1 : 0),
                  '_permission': item._permission,
                  '_title': item._title,
                  '_color': item._color,
                  '_body': item._body,
                  '_creationDate': item._creationDate,
                  '_lastModifiedDate': item._lastModifiedDate,
                  '_categoryId': item._categoryId
                }),
        _memoUpdateAdapter = UpdateAdapter(
            database,
            'Memo',
            ['_id'],
            (Memo item) => <String, Object?>{
                  '_id': item._id,
                  '_isOwner':
                      item._isOwner == null ? null : (item._isOwner! ? 1 : 0),
                  '_permission': item._permission,
                  '_title': item._title,
                  '_color': item._color,
                  '_body': item._body,
                  '_creationDate': item._creationDate,
                  '_lastModifiedDate': item._lastModifiedDate,
                  '_categoryId': item._categoryId
                }),
        _memoDeletionAdapter = DeletionAdapter(
            database,
            'Memo',
            ['_id'],
            (Memo item) => <String, Object?>{
                  '_id': item._id,
                  '_isOwner':
                      item._isOwner == null ? null : (item._isOwner! ? 1 : 0),
                  '_permission': item._permission,
                  '_title': item._title,
                  '_color': item._color,
                  '_body': item._body,
                  '_creationDate': item._creationDate,
                  '_lastModifiedDate': item._lastModifiedDate,
                  '_categoryId': item._categoryId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<Memo> _memoInsertionAdapter;

  final UpdateAdapter<Memo> _memoUpdateAdapter;

  final DeletionAdapter<Memo> _memoDeletionAdapter;

  @override
  Future<void> insertMemo(Memo memo) async {
    await _memoInsertionAdapter.insert(memo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMemo(Memo memo) async {
    await _memoUpdateAdapter.update(memo, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMemo(Memo memo) async {
    await _memoDeletionAdapter.delete(memo);
  }
}

class _$MemoAccountAssociationDao extends MemoAccountAssociationDao {
  _$MemoAccountAssociationDao(this.database, this.changeListener)
      : _memoAccountAssociationInsertionAdapter = InsertionAdapter(
            database,
            'MemoAccountAssociation',
            (MemoAccountAssociation item) => <String, Object?>{
                  '_id': item._id,
                  '_memoId': item._memoId,
                  '_accountId': item._accountId,
                  '_isOwner':
                      item._isOwner == null ? null : (item._isOwner! ? 1 : 0),
                  '_permission': item._permission
                }),
        _memoAccountAssociationUpdateAdapter = UpdateAdapter(
            database,
            'MemoAccountAssociation',
            ['_id'],
            (MemoAccountAssociation item) => <String, Object?>{
                  '_id': item._id,
                  '_memoId': item._memoId,
                  '_accountId': item._accountId,
                  '_isOwner':
                      item._isOwner == null ? null : (item._isOwner! ? 1 : 0),
                  '_permission': item._permission
                }),
        _memoAccountAssociationDeletionAdapter = DeletionAdapter(
            database,
            'MemoAccountAssociation',
            ['_id'],
            (MemoAccountAssociation item) => <String, Object?>{
                  '_id': item._id,
                  '_memoId': item._memoId,
                  '_accountId': item._accountId,
                  '_isOwner':
                      item._isOwner == null ? null : (item._isOwner! ? 1 : 0),
                  '_permission': item._permission
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<MemoAccountAssociation>
      _memoAccountAssociationInsertionAdapter;

  final UpdateAdapter<MemoAccountAssociation>
      _memoAccountAssociationUpdateAdapter;

  final DeletionAdapter<MemoAccountAssociation>
      _memoAccountAssociationDeletionAdapter;

  @override
  Future<void> insertMemoAccountAssociation(
      MemoAccountAssociation memoAccountAssociation) async {
    await _memoAccountAssociationInsertionAdapter.insert(
        memoAccountAssociation, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMemoAccountAssociation(
      MemoAccountAssociation memoAccountAssociation) async {
    await _memoAccountAssociationUpdateAdapter.update(
        memoAccountAssociation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMemoAccountAssociation(
      MemoAccountAssociation memoAccountAssociation) async {
    await _memoAccountAssociationDeletionAdapter.delete(memoAccountAssociation);
  }
}

class _$MemoTagAssociationDao extends MemoTagAssociationDao {
  _$MemoTagAssociationDao(this.database, this.changeListener)
      : _memoTagAssociationInsertionAdapter = InsertionAdapter(
            database,
            'MemoTagAssociation',
            (MemoTagAssociation item) => <String, Object?>{
                  '_id': item._id,
                  '_memoId': item._memoId,
                  '_tagId': item._tagId
                }),
        _memoTagAssociationUpdateAdapter = UpdateAdapter(
            database,
            'MemoTagAssociation',
            ['_id'],
            (MemoTagAssociation item) => <String, Object?>{
                  '_id': item._id,
                  '_memoId': item._memoId,
                  '_tagId': item._tagId
                }),
        _memoTagAssociationDeletionAdapter = DeletionAdapter(
            database,
            'MemoTagAssociation',
            ['_id'],
            (MemoTagAssociation item) => <String, Object?>{
                  '_id': item._id,
                  '_memoId': item._memoId,
                  '_tagId': item._tagId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<MemoTagAssociation>
      _memoTagAssociationInsertionAdapter;

  final UpdateAdapter<MemoTagAssociation> _memoTagAssociationUpdateAdapter;

  final DeletionAdapter<MemoTagAssociation> _memoTagAssociationDeletionAdapter;

  @override
  Future<void> insertMemoAccountAssociation(
      MemoTagAssociation memoTagAssociation) async {
    await _memoTagAssociationInsertionAdapter.insert(
        memoTagAssociation, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMemoAccountAssociation(
      MemoTagAssociation memoTagAssociation) async {
    await _memoTagAssociationUpdateAdapter.update(
        memoTagAssociation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMemoAccountAssociation(
      MemoTagAssociation memoTagAssociation) async {
    await _memoTagAssociationDeletionAdapter.delete(memoTagAssociation);
  }
}

class _$TagDao extends TagDao {
  _$TagDao(this.database, this.changeListener)
      : _memoTagInsertionAdapter = InsertionAdapter(
            database,
            'MemoTag',
            (MemoTag item) => <String, Object?>{
                  '_id': item._id,
                  '_name': item._name,
                  '_description': item._description,
                  '_creationDate': item._creationDate,
                  '_lastModifiedDate': item._lastModifiedDate
                }),
        _memoTagUpdateAdapter = UpdateAdapter(
            database,
            'MemoTag',
            ['_id'],
            (MemoTag item) => <String, Object?>{
                  '_id': item._id,
                  '_name': item._name,
                  '_description': item._description,
                  '_creationDate': item._creationDate,
                  '_lastModifiedDate': item._lastModifiedDate
                }),
        _memoTagDeletionAdapter = DeletionAdapter(
            database,
            'MemoTag',
            ['_id'],
            (MemoTag item) => <String, Object?>{
                  '_id': item._id,
                  '_name': item._name,
                  '_description': item._description,
                  '_creationDate': item._creationDate,
                  '_lastModifiedDate': item._lastModifiedDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<MemoTag> _memoTagInsertionAdapter;

  final UpdateAdapter<MemoTag> _memoTagUpdateAdapter;

  final DeletionAdapter<MemoTag> _memoTagDeletionAdapter;

  @override
  Future<void> insertTag(MemoTag tag) async {
    await _memoTagInsertionAdapter.insert(tag, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTag(MemoTag tag) async {
    await _memoTagUpdateAdapter.update(tag, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTag(MemoTag tag) async {
    await _memoTagDeletionAdapter.delete(tag);
  }
}
