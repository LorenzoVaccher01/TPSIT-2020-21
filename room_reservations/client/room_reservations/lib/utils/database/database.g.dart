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

  TeacherDao _teacherDaoInstance;

  SchoolClassDao _schoolClassDaoInstance;

  RoomDao _roomDaoInstance;

  EventDao _eventDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Event` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `dateFrom` TEXT, `dateTo` TEXT, `teacherId` INTEGER, `schoolClassId` INTEGER, `roomId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Teacher` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `email` TEXT, `concourseClass` TEXT, `profileImage` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SchoolClass` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `section` TEXT, `year` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Room` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `identificator` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TeacherDao get teacherDao {
    return _teacherDaoInstance ??= _$TeacherDao(database, changeListener);
  }

  @override
  SchoolClassDao get schoolClassDao {
    return _schoolClassDaoInstance ??=
        _$SchoolClassDao(database, changeListener);
  }

  @override
  RoomDao get roomDao {
    return _roomDaoInstance ??= _$RoomDao(database, changeListener);
  }

  @override
  EventDao get eventDao {
    return _eventDaoInstance ??= _$EventDao(database, changeListener);
  }
}

class _$TeacherDao extends TeacherDao {
  _$TeacherDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Teacher>> findAllTeacher() async {
    return _queryAdapter.queryList('SELECT * FROM Teacher',
        mapper: (Map<String, dynamic> row) => Teacher(
            row['id'] as int,
            row['name'] as String,
            row['email'] as String,
            row['concourseClass'] as String,
            row['profileImage'] as String));
  }
}

class _$SchoolClassDao extends SchoolClassDao {
  _$SchoolClassDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<SchoolClass>> findAllSchoolClass() async {
    return _queryAdapter.queryList('SELECT * FROM SchoolClass',
        mapper: (Map<String, dynamic> row) => SchoolClass(
            row['id'] as int, row['section'] as String, row['year'] as int));
  }
}

class _$RoomDao extends RoomDao {
  _$RoomDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Room>> findAllRoom() async {
    return _queryAdapter.queryList('SELECT * FROM Room',
        mapper: (Map<String, dynamic> row) =>
            Room(row['id'] as int, row['identificator'] as String));
  }
}

class _$EventDao extends EventDao {
  _$EventDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Event>> findAllEvent() async {
    return _queryAdapter.queryList('SELECT * FROM Event',
        mapper: (Map<String, dynamic> row) => Event(
            row['id'] as int,
            row['dateFrom'] as String,
            row['dateTo'] as String,
            row['teacherId'] as int,
            row['schoolClassId'] as int,
            row['roomId'] as int));
  }
}
