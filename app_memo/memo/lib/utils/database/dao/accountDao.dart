import 'package:floor/floor.dart';
import '../models/account.dart';

@dao
abstract class AccountDao {
  @Query('SELECT * FROM Account')
  Future<List<FloorAccount>> findAllAccount();

  @Query('SELECT * FROM Account WHERE id = :id')
  Future<List<FloorAccount>> findAccountById(int id);

  @Query('SELECT * FROM Account WHERE email = :email')
  Future<List<FloorAccount>> findAccountByEmail(String email);

  @delete
  Future<void> deleteAccount(FloorAccount account);

  @update
  Future<void> updateAccount(FloorAccount account);

  @insert
  Future<void> insertAccount(FloorAccount account);
}
