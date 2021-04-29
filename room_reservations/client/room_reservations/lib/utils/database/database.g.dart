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
            'CREATE TABLE IF NOT EXISTS `EventFloor` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `dateFrom` TEXT, `dateTo` TEXT, `teacherId` INTEGER, `schoolClassId` INTEGER, `roomId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TeacherFloor` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `email` TEXT, `concourseClass` TEXT, `profileImage` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SchoolClassFloor` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `section` TEXT, `year` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RoomFloor` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `identificator` TEXT)');

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
      : _queryAdapter = QueryAdapter(database),
        _teacherFloorInsertionAdapter = InsertionAdapter(
            database,
            'TeacherFloor',
            (TeacherFloor item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'concourseClass': item.concourseClass,
                  'profileImage': item.profileImage
                }),
        _teacherFloorDeletionAdapter = DeletionAdapter(
            database,
            'TeacherFloor',
            ['id'],
            (TeacherFloor item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'concourseClass': item.concourseClass,
                  'profileImage': item.profileImage
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TeacherFloor> _teacherFloorInsertionAdapter;

  final DeletionAdapter<TeacherFloor> _teacherFloorDeletionAdapter;

  @override
  Future<List<TeacherFloor>> getAllTeachers() async {
    return _queryAdapter.queryList('SELECT * FROM Teacher',
        mapper: (Map<String, dynamic> row) => TeacherFloor(
            row['id'] as int,
            row['name'] as String,
            row['email'] as String,
            row['concourseClass'] as String,
            row['profileImage'] as String));
  }

  @override
  Future<TeacherFloor> getTeacherById(int id) async {
    return _queryAdapter.query('SELECT * FROM Teacher WHERE id= ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => TeacherFloor(
            row['id'] as int,
            row['name'] as String,
            row['email'] as String,
            row['concourseClass'] as String,
            row['profileImage'] as String));
  }

  @override
  Future<void> deleteTeacherById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Teacher WHERE id= ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertTeacher(TeacherFloor teacher) async {
    await _teacherFloorInsertionAdapter.insert(
        teacher, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTeacher(TeacherFloor teacher) async {
    await _teacherFloorDeletionAdapter.delete(teacher);
  }
}

class _$SchoolClassDao extends SchoolClassDao {
  _$SchoolClassDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _schoolClassFloorInsertionAdapter = InsertionAdapter(
            database,
            'SchoolClassFloor',
            (SchoolClassFloor item) => <String, dynamic>{
                  'id': item.id,
                  'section': item.section,
                  'year': item.year
                }),
        _schoolClassFloorDeletionAdapter = DeletionAdapter(
            database,
            'SchoolClassFloor',
            ['id'],
            (SchoolClassFloor item) => <String, dynamic>{
                  'id': item.id,
                  'section': item.section,
                  'year': item.year
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SchoolClassFloor> _schoolClassFloorInsertionAdapter;

  final DeletionAdapter<SchoolClassFloor> _schoolClassFloorDeletionAdapter;

  @override
  Future<List<SchoolClassFloor>> getAllSchoolClass() async {
    return _queryAdapter.queryList('SELECT * FROM SchoolClass',
        mapper: (Map<String, dynamic> row) => SchoolClassFloor(
            row['id'] as int, row['section'] as String, row['year'] as int));
  }

  @override
  Future<SchoolClassFloor> getSchoolClassById(int id) async {
    return _queryAdapter.query('SELECT * FROM SchoolClass WHERE id= ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => SchoolClassFloor(
            row['id'] as int, row['section'] as String, row['year'] as int));
  }

  @override
  Future<void> deleteSchoolClassById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM SchoolClass WHERE id= ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertSchoolClass(SchoolClassFloor schoolClass) async {
    await _schoolClassFloorInsertionAdapter.insert(
        schoolClass, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSchoolClass(SchoolClassFloor schoolClass) async {
    await _schoolClassFloorDeletionAdapter.delete(schoolClass);
  }
}

class _$RoomDao extends RoomDao {
  _$RoomDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _roomFloorInsertionAdapter = InsertionAdapter(
            database,
            'RoomFloor',
            (RoomFloor item) => <String, dynamic>{
                  'id': item.id,
                  'identificator': item.identificator
                }),
        _roomFloorDeletionAdapter = DeletionAdapter(
            database,
            'RoomFloor',
            ['id'],
            (RoomFloor item) => <String, dynamic>{
                  'id': item.id,
                  'identificator': item.identificator
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RoomFloor> _roomFloorInsertionAdapter;

  final DeletionAdapter<RoomFloor> _roomFloorDeletionAdapter;

  @override
  Future<List<RoomFloor>> getAllRooms() async {
    return _queryAdapter.queryList('SELECT * FROM Room',
        mapper: (Map<String, dynamic> row) =>
            RoomFloor(row['id'] as int, row['identificator'] as String));
  }

  @override
  Future<RoomFloor> getRoomById(int id) async {
    return _queryAdapter.query('SELECT * FROM Room WHERE id= ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) =>
            RoomFloor(row['id'] as int, row['identificator'] as String));
  }

  @override
  Future<void> deleteRoomById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Room WHERE id= ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertRoom(RoomFloor room) async {
    await _roomFloorInsertionAdapter.insert(room, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRoom(RoomFloor room) async {
    await _roomFloorDeletionAdapter.delete(room);
  }
}

class _$EventDao extends EventDao {
  _$EventDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _eventFloorInsertionAdapter = InsertionAdapter(
            database,
            'EventFloor',
            (EventFloor item) => <String, dynamic>{
                  'id': item.id,
                  'dateFrom': item.dateFrom,
                  'dateTo': item.dateTo,
                  'teacherId': item.teacherId,
                  'schoolClassId': item.schoolClassId,
                  'roomId': item.roomId
                }),
        _eventFloorDeletionAdapter = DeletionAdapter(
            database,
            'EventFloor',
            ['id'],
            (EventFloor item) => <String, dynamic>{
                  'id': item.id,
                  'dateFrom': item.dateFrom,
                  'dateTo': item.dateTo,
                  'teacherId': item.teacherId,
                  'schoolClassId': item.schoolClassId,
                  'roomId': item.roomId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<EventFloor> _eventFloorInsertionAdapter;

  final DeletionAdapter<EventFloor> _eventFloorDeletionAdapter;

  @override
  Future<List<EventFloor>> getAllEvents() async {
    return _queryAdapter.queryList('SELECT * FROM Event',
        mapper: (Map<String, dynamic> row) => EventFloor(
            row['id'] as int,
            row['dateFrom'] as String,
            row['dateTo'] as String,
            row['teacherId'] as int,
            row['schoolClassId'] as int,
            row['roomId'] as int));
  }

  @override
  Future<EventFloor> getEventById(int id) async {
    return _queryAdapter.query('SELECT * FROM Event WHERE id= ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => EventFloor(
            row['id'] as int,
            row['dateFrom'] as String,
            row['dateTo'] as String,
            row['teacherId'] as int,
            row['schoolClassId'] as int,
            row['roomId'] as int));
  }

  @override
  Future<void> deleteEventById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Event WHERE id= ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertEvent(EventFloor event) async {
    await _eventFloorInsertionAdapter.insert(event, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEvent(EventFloor event) async {
    await _eventFloorDeletionAdapter.delete(event);
  }
}
