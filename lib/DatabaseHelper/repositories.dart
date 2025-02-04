import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';
import 'package:zaitoon_invoice/Json/users.dart';

class Repositories {

  //Register User With New Database
  Future<int> createNewDatabase({
      required Users usr,
      required String path,
      required String dbName}) async {
    await DatabaseHelper.initDatabase(path: path, dbName: dbName);
    final db = DatabaseHelper.db;

    final stmt = db.prepare('''INSERT INTO ${Tables.appMetadataTableName}
    (ownerName,businessName,email,address,mobile1,mobile2) values (?,?,?,?,?,?)''');

    //Business
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

    /////////////////////////////////////////////////////////////////////


    final stmt2 = db.prepare('''INSERT INTO ${Tables.userTableName}
    (businessId, userStatus, username, password, createdBy) 
    values(?,?,?,?,?)''');


      final hashedPassword = DatabaseComponents.hashPassword(usr.password!);
      stmt2.execute([
        businessId, //Business Id
        usr.userStatus, //User Status default 1
        usr.username,  //Username//CreatedBy - userId
        hashedPassword, // Encrypted Password
        usr.userId ?? businessId,
      ]);
      final userId = db.lastInsertRowId;
      stmt2.dispose();


    final stmt3 = db.prepare('''INSERT INTO ${Tables.permissionTableName} 
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)''');

    //Permissions
    stmt3.execute([usr.userId, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
    final permissionId = db.lastInsertRowId;
    stmt.dispose();


    final stmt4 = db.prepare( '''INSERT INTO ${Tables.rolePermissionTableName} 
    (role, permission, user) VALUES (?,?,?)''');

    stmt4.execute([
      1,permissionId, userId
    ]);
    stmt4.dispose();


    final stmt5 = db.prepare('''INSERT INTO ${Tables.accountTableName} 
    (accountName, mobile, address, email, createdBy, accountCategory, accountDefaultCurrency)
    VALUES (?,?,?,?,?,?,?)
     ''');

    //Create New Account
    stmt5.execute([
      usr.ownerName, // Account Name
      usr.mobile1,   // Mobile
      usr.address,   // Address
      usr.email,     //  Email
      userId,        //  Created By
      8,             // Account Category
      1              // currency
    ]);
    stmt5.dispose();

    return businessId;
  }

  Future<Map<String, dynamic>> login({required Users user}) async {
    final db = DatabaseHelper.db;

    // Query to check if the user exists in the database
    final result = db.select('''
    SELECT * FROM ${Tables.userTableName} WHERE username = ?
    ''', [user.username]);

    if (result.isNotEmpty) {
      final storedHashedPassword = result.first['password'];
      final usrStatus = result.first['userStatus'];

      // First, verify if the password is correct
      if (DatabaseComponents.verifyPassword(
          user.password!, storedHashedPassword)) {
        // If the password is correct, check the user's status
        if (usrStatus == 0) {
          return {'success': false, 'code': 'USER_INACTIVE'}; // User is blocked
        } else {
          return {'success': true, 'code': 'LOGIN_SUCCESS'}; // Login successful
        }
      } else {
        return {
          'success': false,
          'code': 'WRONG_PASSWORD'
        }; // Incorrect password
      }
    } else {
      return {'success': false, 'code': 'USER_NOT_FOUND'}; // Username not found
    }
  }

  //User Flow - Logged In User
  Future<Users> getCurrentUser({required username}) async {
    final db = DatabaseHelper.db;
    final usr = db.select('''
    SELECT user.*, meta.*, role.*
    FROM ${Tables.userTableName} as user INNER JOIN ${Tables.appMetadataTableName} as meta
    ON user.businessId = meta.bId INNER JOIN ${Tables.userRoleTableName} as role
    ON user.userRoleId = role.roleId
    WHERE username = ?
   ''', [username]);
    if (usr.isNotEmpty) {
      return Users.fromMap(usr.first);
    } else {
      throw "Username [$username] not found";
    }
  }

  //User Flow - Logged In User
  Future<Users> getUserById({required int userId}) async {
    final db = DatabaseHelper.db;
    final usr = db.select('''
    SELECT user.*, meta.*, role.*
    FROM ${Tables.userTableName} as user INNER JOIN ${Tables.appMetadataTableName} as meta
    ON user.businessId = meta.bId INNER JOIN ${Tables.userRoleTableName} as role
    ON user.userRoleId = role.roleId
    WHERE user.userId = ?
   ''', [userId]);
    if (usr.isNotEmpty) {
      return Users.fromMap(usr.first);
    } else {
      throw "Username [$userId] not found";
    }
  }

  Future<int> updateAccount({required Users user}) async {
    final db = DatabaseHelper.db;
    final stmt = db.prepare('''
    UPDATE ${Tables.appMetadataTableName} SET 
    businessName = ?, 
    ownerName = ?, 
    mobile1 = ?, 
    mobile2 = ?, 
    address = ?, 
    email = ?
    WHERE bId = ?
    ''');
    stmt.execute([
      user.businessName,
      user.ownerName,
      user.mobile1,
      user.mobile2,
      user.address,
      user.email,
      user.businessId,
    ]);
    return db.updatedRows;
  }

  Future<int> uploadLogo({required Users user}) async {
    final db = DatabaseHelper.db;
    final stmt = db.prepare('''
    UPDATE ${Tables.appMetadataTableName} SET 
    companyLogo = ?
    WHERE bId = ?
    ''');
    stmt.execute([
      user.companyLogo,
      user.businessId,
    ]);
    return db.updatedRows;
  }

  Future<int> changePassword(
      {required String oldPassword,
      required String newPassword,
      required int userId,
      required String message}) async {
    final db = DatabaseHelper.db;
    final response = db.select(
        '''SELECT * FROM ${Tables.userTableName} WHERE userId = ? ''',
        [userId]);
    final encryptedPassword = response.first['password'];
    if (response.isNotEmpty &&
        DatabaseComponents.verifyPassword(oldPassword, encryptedPassword)) {
      final newEncryptedPassword = DatabaseComponents.hashPassword(newPassword);
      final stmt = db.prepare(
          '''UPDATE ${Tables.userTableName} SET password = ? WHERE userId = ?
      ''');
      stmt.execute([newEncryptedPassword, userId]);
      db.dispose();
      return db.updatedRows;
    } else {
      throw message; // Password verification failed
    }
  }
}
