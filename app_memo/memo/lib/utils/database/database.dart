import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

import 'models/memo.dart';
import 'models/tag.dart';
import 'models/account.dart';
import 'models/category.dart';
import 'models/memoAccountAssociation.dart';
import 'models/memoTagAssociation.dart';

import 'dao/accountDao.dart';
import 'dao/categoryDao.dart';
import 'dao/tagDao.dart';

import 'dao/memoAccountAssociationDao.dart';
import 'dao/memoTagAssociationDao.dart';
import 'dao/memoDao.dart';

part 'database.g.dart';
@Database(version: 1, entities: [
  FloorAccount,
  FloorCategory,
  FloorMemo,
  FloorMemoAccountAssociation,
  FloorMemoTagAssociation,
  FloorTag
])

abstract class AppDatabase extends FloorDatabase {
  AccountDao get accountDao;
  CategoryDao get categoryDao;
  MemoDao get memoDao;
  MemoAccountAssociationDao get memoAccountAssociationDao;
  MemoTagAssociationDao get memoTagAssociationDao;
  TagDao get tagDao;
}
