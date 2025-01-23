import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';
import 'package:zaitoon_invoice/Json/users.dart';

class Repositories {

  //Register User With New Database
  Future<int> createNewDatabase({required Users usr, required String dbName}) async {
    await DatabaseHelper.initDatabase(dbName);
    final db = DatabaseHelper.db;
    final stmt = db.prepare(
        '''INSERT INTO ${Tables.userTableName}
         (fullName,businessName,email,address,mobile,telephone,username,password)
         values (?,?,?,?,?,?,?,?)''');
    final hashedPassword = DatabaseComponents.hashPassword(usr.password!);
    stmt.execute([
      usr.fullName,
      usr.businessName,
      usr.email,
      usr.address,
      usr.mobile,
      usr.telephone,
      usr.username,
      hashedPassword
    ]);
    stmt.dispose();
    final lastInsertedId = db.lastInsertRowId;
    return lastInsertedId;
  }

  //Login
  Future<bool> login({required Users user}) async {
    final db = DatabaseHelper.db;
    final result = db.select('''
    SELECT * FROM ${Tables.userTableName} WHERE username = ?
   ''', [user.username]);
    if (result.isNotEmpty) {
      final storedHashedPassword = result.first['password'];
      if (DatabaseComponents.verifyPassword(user.password!, storedHashedPassword)) {
       return true;
      } else {
        return false;
      }
    }else{
      return false;
    }
  }

  //User Flow - Logged In User
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
