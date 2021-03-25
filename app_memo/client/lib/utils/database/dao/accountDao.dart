import 'package:floor/floor.dart';
import '../models/account.dart';

@dao
abstract class AccountDao {
  /*@Query('SELECT * FROM Account')
  Future<List<Account>> findAllAccount();*/

  @delete
  Future<void> deleteAccount(Account account);

  @update
  Future<void> updateAccount(Account account);

  @insert
  Future<void> insertAccount(Account account);
}
