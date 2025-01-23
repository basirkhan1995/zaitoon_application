import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';
import 'package:zaitoon_invoice/Json/users.dart';

class Repositories {
  Future<void> createUser({required Users usr}) async {
    final db = DatabaseHelper.db;
    final stm = db.prepare(
        '''INSERT INTO ${Tables.userTableName} VALUES (?,?,?,?,?,?,?,?)''');
    stm.execute([
      usr.copyWith(username: usr.username),
      usr.copyWith(username: usr.password),
      usr.copyWith(username: usr.businessName),
      usr.copyWith(username: usr.fullName),
      usr.copyWith(username: usr.telephone),
      usr.copyWith(username: usr.phone),
      usr.copyWith(username: usr.address),
      usr.copyWith(username: usr.email),
    ]);
  }

  Future<bool> login({required Users user}) async {
    final db = DatabaseHelper.db;
    final res = db.select('''
    SELECT * FROM ${Tables.userTableName} WHERE username = ? AND password = ?
   ''', [user.copyWith(username: user.username, password: user.password)]);
    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<Users> getCurrentUser({required username}) async {
    final db = DatabaseHelper.db;
    final usr = db.select('''
    SELECT * FROM ${Tables.userTableName} WHERE username = ?
    ''', [username]);
    if (usr.isNotEmpty) {
      return Users.fromMap(usr.first);
    } else {
      throw "Username [$username] not found";
    }
  }
}
