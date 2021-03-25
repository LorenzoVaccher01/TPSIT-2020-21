import 'package:floor/floor.dart';

@entity
class FloorAccount {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String surname;
  final String email;
  final String registrationDate;
  final String lastAccessDate;

  FloorAccount(this.id, this.name, this.surname, this.email, this.registrationDate, this.lastAccessDate);
}
