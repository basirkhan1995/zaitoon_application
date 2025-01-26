import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';
import 'package:zaitoon_invoice/Json/users.dart';

class Repositories {
  //Register User With New Database
  Future<int> createNewDatabase(
      {required Users usr, required String dbName}) async {
    await DatabaseHelper.initDatabase(dbName);
    final db = DatabaseHelper.db;

    final stmt = db.prepare('''INSERT INTO ${Tables.appMetadataTableName}
    (ownerName,businessName,email,address,mobile1,mobile2) values (?,?,?,?,?,?)''');

    final stmt2 = db.prepare('''INSERT INTO ${Tables.userTableName}
    (businessId, userStatus, userRoleId, username,password) 
    values(?,?,?,?,?)''');

    stmt.execute([
      usr.ownerName,
      usr.businessName,
      usr.email,
      usr.address,
      usr.mobile1,
      usr.mobile2,
    ]);
    final businessId = db.lastInsertRowId;
    stmt.dispose();

    if (businessId > 0) {
      final hashedPassword = DatabaseComponents.hashPassword(usr.password!);
      stmt2.execute([
        businessId, //Business Id
        usr.userStatus, //User Status default 1
        usr.userRoleId, //User Role default 1 = admin
        usr.username,
        hashedPassword, // Encripted Password
      ]);
      stmt2.dispose();
    }

    return businessId;
  }

  //Login
  Future<bool> login({required Users user}) async {
    final db = DatabaseHelper.db;
    final result = db.select('''
    SELECT * FROM ${Tables.userTableName} WHERE username = ?
    ''', [user.username]);
    if (result.isNotEmpty) {
      final storedHashedPassword = result.first['password'];
      final usrStatus = result.first['userStatus'];
      if (usrStatus == 0) {
        print(usrStatus);
        print("You are blocked");
        return false;
      }
      if (DatabaseComponents.verifyPassword(
          user.password!, storedHashedPassword)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //User Flow - Logged In User
  Future<Users> getCurrentUser({required username}) async {
    final db = DatabaseHelper.db;
    final usr = db.select('''
    SELECT u.*, a.*
    FROM ${Tables.userTableName} as u JOIN ${Tables.appMetadataTableName} as a
    ON u.businessId = a.bId
    WHERE username = ?
   ''', [username]);
    if (usr.isNotEmpty) {
      return Users.fromMap(usr.first);
    } else {
      throw "Username [$username] not found";
    }
  }
}
