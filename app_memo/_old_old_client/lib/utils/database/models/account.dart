import 'package:floor/floor.dart';

@entity
class Account {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String surname;
  final String email;
  final String registrationDate;
  final String lastAccessDate;

  Account(this.id, this.name, this.surname, this.email, this.registrationDate, this.lastAccessDate);
}
