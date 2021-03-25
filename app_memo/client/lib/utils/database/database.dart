import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

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
  Account,
  MemoCategory,
  Memo,
  MemoAccountAssociation,
  MemoTagAssociation,
  MemoTag
])

abstract class AppDatabase extends FloorDatabase {
  AccountDao get accountDao;
  CategoryDao get category;
  MemoDao get memo;
  MemoAccountAssociationDao get memoAccountAssociation;
  MemoTagAssociationDao get memoTagAssociation;
  TagDao get memoTag;
}
