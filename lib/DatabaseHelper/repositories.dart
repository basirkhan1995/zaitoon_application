import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';
import 'package:zaitoon_invoice/Json/accounts_model.dart';
import 'package:zaitoon_invoice/Json/currencies_model.dart';
import 'package:zaitoon_invoice/Json/inventory_model.dart';
import 'package:zaitoon_invoice/Json/product_category.dart';
import 'package:zaitoon_invoice/Json/product_model.dart';
import 'package:zaitoon_invoice/Json/products_report_model.dart';
import 'package:zaitoon_invoice/Json/users.dart';

import '../Json/product_unit.dart';

class Repositories {
  //Register User With New Database
  Future<int> createNewDatabase(
      {required Users usr,
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

    final stmt2 = db.prepare('''INSERT INTO ${Tables.userTableName}
    (businessId, userStatus, username, password, createdBy) 
    values(?,?,?,?,?)''');

    final hashedPassword = DatabaseComponents.hashPassword(usr.password!);
    stmt2.execute([
      businessId, //Business Id
      usr.userStatus, //User Status default 1
      usr.username, //Username//CreatedBy - userId
      hashedPassword, // Encrypted Password
      usr.userId ?? businessId
    ]);
    final userId = db.lastInsertRowId;
    stmt2.dispose();

    final stmt3 = db.prepare('''INSERT INTO ${Tables.permissionTableName} 
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)''');

    //Permissions
    stmt3.execute(
        [usr.userId, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
    final permissionId = db.lastInsertRowId;
    stmt.dispose();

    final stmt4 = db.prepare('''INSERT INTO ${Tables.rolePermissionTableName} 
    (permission, user) VALUES (?,?)''');

    stmt4.execute([permissionId, userId]);
    stmt4.dispose();

    final stmt5 = db.prepare('''INSERT INTO ${Tables.accountTableName} 
    (accId,accountName, mobile, address, email, createdBy, accountCategory, accountDefaultCurrency)
    VALUES (?,?,?,?,?,?,?,?)
     ''');

    //Create New Account
    stmt5.execute([
      100,
      usr.ownerName, // Account Name
      usr.mobile1, // Mobile
      usr.address, // Address
      usr.email, //  Email
      userId, //  Created By
      8, // Account Category - admin
      'AFN' // account default currency
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
    SELECT user.*, meta.*
    FROM ${Tables.userTableName} as user INNER JOIN ${Tables.appMetadataTableName} as meta
    ON user.businessId = meta.bId
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
    SELECT user.*, meta.*
    FROM ${Tables.userTableName} as user INNER JOIN ${Tables.appMetadataTableName} as meta
    ON user.businessId = meta.bId
    WHERE user.usrId = ?
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

  Future<int> changePassword({
    required String oldPassword,
    required String newPassword,
    required int userId,
    required String message,
  }) async {
    final db = DatabaseHelper.db;

    // Fetch user securely
    final response = await Future(() => db.select(
        '''SELECT password FROM ${Tables.userTableName} WHERE usrId = ?''',
        [userId]));

    if (response.isEmpty) {
      throw 'User not found'; // Handle non-existent user
    }

    final encryptedPassword = response.first['password'];

    // Verify old password
    if (!DatabaseComponents.verifyPassword(oldPassword, encryptedPassword)) {
      throw message; // Password mismatch
    }

    // Encrypt new password
    final newEncryptedPassword = DatabaseComponents.hashPassword(newPassword);

    // Perform update
    final stmt = db.prepare(
        '''UPDATE ${Tables.userTableName} SET password = ? WHERE userId = ?''');

    stmt.execute([newEncryptedPassword, userId]);
    stmt.dispose(); // Dispose prepared statement

    final affectedRows = db.updatedRows; // Store affected rows count

    return affectedRows; // Return count of updated rows
  }

  Future<List<Accounts>> getAccounts() async {
    final db = DatabaseHelper.db;

    final response = await Future(() => db.select('''
    SELECT acc.*, currency.currency_code, category.* 
    FROM ${Tables.accountTableName} AS acc
    INNER JOIN ${Tables.currencyTableName} AS currency 
      ON acc.accountDefaultCurrency = currency.currency_code
    INNER JOIN ${Tables.accountCategoryTableName} AS category 
      ON acc.accountCategory = category.accCategoryId
  ''')); // Run synchronously inside Future to prevent blocking

    return response.map((row) => Accounts.fromMap(row)).toList();
  }

  Future<List<Accounts>> getAccountsByCategory(
      {required List<String> categories}) async {
    final db = DatabaseHelper.db;

    if (categories.isEmpty) {
      return []; // Return empty list if no categories are provided
    }

    // Generate dynamic placeholders (?, ?, ?, ...) based on category count
    final placeholders = List.filled(categories.length, '?').join(', ');

    final response = db.select('''
    SELECT acc.*, currency.currency_code, category.* 
    FROM ${Tables.accountTableName} AS acc
    INNER JOIN ${Tables.currencyTableName} AS currency 
      ON acc.accountDefaultCurrency = currency.currency_code
    INNER JOIN ${Tables.accountCategoryTableName} AS category 
      ON acc.accountCategory = category.accCategoryId
    WHERE category.accCategoryName IN ($placeholders)
  ''', categories); // Directly pass list elements as parameters

    return response.map((row) => Accounts.fromMap(row)).toList();
  }

  Future<List<Accounts>> searchAccounts({required String keyword}) async {
    final db = DatabaseHelper.db;
    // Check if the keyword is numeric
    final isNumeric = int.tryParse(keyword) != null;
    final response = db.select( '''
    SELECT accId, accountName FROM ${Tables.accountTableName} 
    WHERE (:keyword IS NULL OR :keyword = '' OR accId = :keyword OR accountName LIKE '%' || :keyword || '%')''',
    isNumeric ? [keyword] : ["%$keyword%"]);
    return response.map((e) => Accounts.fromMap(e)).toList();
  }

  //Products
  Future<int> createProduct({
    required String productName,
    required int unit,
    required int category,
    required double buyPrice,
    required double sellPrice,
    required int inventory,
    required int qty,
  }) async {
    final db = DatabaseHelper.db;
    final invType = "IN";

    try {

      // Insert product into product table
      final stmt = db.prepare('''
      INSERT INTO ${Tables.productTableName} (productName, unit, category) 
      VALUES (?,?,?)''');
      stmt.execute([productName, unit, category]);
      final productId = db.lastInsertRowId; // Get productId after insert
      stmt.dispose();

      // Insert product inventory only if inventory and qty are greater than zero
      if (inventory > 0 && qty > 0) {
        final stmt2 = db.prepare('''
        INSERT INTO ${Tables.productInventoryTableName} (product, inventory, qty, inventoryType, buyPrice, sellPrice) 
        VALUES (?,?,?,?,?,?)''');
        stmt2
            .execute([productId, inventory, qty, invType, buyPrice, sellPrice]);
        stmt2.dispose();
      }else{
        null;
      }

      return productId;
    } catch (e) {
      throw Exception('Error inserting product and inventory: $e');
    }
  }

  Future<int> deleteProduct({required int id}) async {
    final db = DatabaseHelper.db;
    db.execute('PRAGMA foreign_keys = ON;'); // Enable foreign key constraints
    final stmt = db.prepare(
        ''' DELETE FROM ${Tables.productTableName} WHERE productId = ?''');
    stmt.execute([id]);
    final lastRowId = db.lastInsertRowId;
    stmt.dispose();
    return lastRowId;
  }

  Future<List<InventoryBalance>> productsReport(
      {int? productId, int? inventoryId}) async {
    // Access the database
    final db = DatabaseHelper.db;
    const query = '''
WITH InventoryBalance AS (
    SELECT 
        p.productId, 
        p.productName, 
        pi.proInvId, 
        pi.inventoryType, 
        pi.qty, 
        pi.buyPrice, 
        pi.sellPrice, 
        pi.last_updated,
        i.invId, 
        i.inventoryName,

        -- Calculate running balance of inventory after each transaction
        SUM(CASE 
            WHEN pi.inventoryType = 'IN' THEN pi.qty
            WHEN pi.inventoryType = 'OUT' THEN -pi.qty
            ELSE 0 
        END) OVER (
            PARTITION BY p.productId 
            ORDER BY pi.last_updated, pi.proInvId
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS totalInventory  -- Running balance after each transaction

    FROM 
        products AS p
    LEFT JOIN 
        productCategoryTbl AS c ON p.category = c.pcId
    LEFT JOIN 
        productUnitTbl AS u ON p.unit = u.unitId
    LEFT JOIN 
        productInventoryTbl AS pi ON p.productId = pi.product
    LEFT JOIN 
        inventoriesTbl AS i ON pi.inventory = i.invId
    WHERE 
        -- Filter by product (if provided)
        (? IS NULL OR p.productId = ?)
        AND
        -- Filter by inventory (if provided)
        (? IS NULL OR i.invId = ?)
)
-- Select the result with the calculated inventory balance for each transaction
SELECT 
    productId,
    productName,
    proInvId, 
    inventoryType, 
    qty, 
    buyPrice, 
    sellPrice, 
    last_updated, 
    invId, 
    inventoryName,
    totalInventory
FROM 
    InventoryBalance
ORDER BY 
    last_updated ASC, proInvId;
  ''';

    // Execute the query with parameters
    final result =
        db.select(query, [productId, productId, inventoryId, inventoryId]);

    // Map the result to your model
    return result.map((e) => InventoryBalance.fromMap(e)).toList();
  }

  Future<List<ProductsModel>> getProductsWithTotalInventory() async {
    final db = DatabaseHelper.db;
    final response = await Future(() => db.select('''
    SELECT 
    p.productId, 
    p.productName, 

    -- Last Buy Price from the most recent 'IN' transaction in productInventoryTbl
    (SELECT pi.buyPrice 
     FROM productInventoryTbl AS pi
     WHERE pi.product = p.productId AND pi.inventoryType = 'IN'
     ORDER BY pi.last_updated DESC 
    )AS lastBuyPrice, 

    -- Last Sell Price from the most recent 'IN' transaction in productInventoryTbl
    (SELECT pi.sellPrice
     FROM productInventoryTbl AS pi
     WHERE pi.product = p.productId AND pi.inventoryType = 'IN'
     ORDER BY pi.last_updated DESC 
    ) AS lastSellPrice,

    u.unitId, 
    u.unitName, 
    c.pcId, 
    c.pcName, 
    p.productSerial, 
    i.invId, 
    i.inventoryName, 

    -- Total Available Inventory Calculation
    COALESCE(SUM(CASE 
        WHEN pi.inventoryType = 'IN' THEN pi.qty 
        WHEN pi.inventoryType = 'OUT' THEN -pi.qty 
        ELSE 0 
    END), 0) AS totalInventory, 

    -- Average Buy Price from Last 10 'IN' Transactions in productInventoryTbl
    (SELECT AVG(sub_pi.buyPrice) 
     FROM (
         SELECT pi.buyPrice
         FROM productInventoryTbl AS pi
         WHERE pi.product = p.productId AND pi.inventoryType = 'IN'
         ORDER BY pi.last_updated DESC 
         LIMIT 10
     ) AS sub_pi
    ) AS averageBuyPrice,

    -- Last Updated Inventory Transaction
    MAX(pi.last_updated) AS lastUpdated
   FROM 
    productsTbl AS p
   LEFT JOIN 
    productCategoryTbl AS c ON p.category = c.pcId
   LEFT JOIN 
    productUnitTbl AS u ON p.unit = u.unitId
   LEFT JOIN 
    productInventoryTbl AS pi ON p.productId = pi.product
   LEFT JOIN 
    inventoriesTbl AS i ON pi.inventory = i.invId

    GROUP BY 
    p.productId, p.productName, 
    u.unitId, u.unitName, c.pcId, c.pcName, 
    p.productSerial, i.invId, i.inventoryName;
    
    '''));
    return response.map((row) => ProductsModel.fromMap(row)).toList();
  }

  //Products Category
  Future<List<ProductsCategoryModel>> getProductCategories() async {
    final db = DatabaseHelper.db;
    final response = await Future(() =>
        db.select('''SELECT * FROM ${Tables.productCategoryTableName}'''));
    return response.map((row) => ProductsCategoryModel.fromMap(row)).toList();
  }

  //Search products by ID & Name
  Future<List<ProductsModel>> searchProducts(String keyword) async {
    final db = DatabaseHelper.db;
    // Check if the keyword is numeric
    final isNumeric = int.tryParse(keyword) != null;
    // Construct the query dynamically
    final items = await Future(() => db.select('''
    SELECT products.*, unit.*
    FROM ${Tables.productTableName} as products
    INNER JOIN ${Tables.productUnitTableName} as unit ON products.unit = unit.unitId
    WHERE ${isNumeric ? "productId = ?" : "productName LIKE ? "}
  ''', isNumeric ? [keyword] : ["%$keyword%"]));
    return items.map((e) => ProductsModel.fromMap(e)).toList();
  }

  //Product Unit
  Future<List<ProductsUnitModel>> getProductUnits() async {
    final db = DatabaseHelper.db;
    final response = await Future(
        () => db.select('''SELECT * FROM ${Tables.productUnitTableName}'''));
    return response.map((row) => ProductsUnitModel.fromMap(row)).toList();
  }

  //Currencies
  Future<List<CurrenciesModel>> getCurrencies() async {
    final db = DatabaseHelper.db;
    final response = await Future(
        () => db.select('''SELECT * FROM ${Tables.currencyTableName}'''));
    return response.map((row) => CurrenciesModel.fromMap(row)).toList();
  }

  static Future<bool> checkIfProductExists(String productName) async {
    try {
      final db = DatabaseHelper.db;
      final result = db.select(
        'SELECT COUNT(*) AS count FROM ${Tables.productTableName} WHERE productName = ?',
        [productName],
      );
      final count = result.first['count'] as int;
      return count > 0; // Return true if the product already exists
    } catch (e) {
      return false;
    }
  }

  //Currencies
  Future<List<InventoryModel>> getInventories() async {
    final db = DatabaseHelper.db;
    final response = await Future(
        () => db.select('''SELECT * FROM ${Tables.inventoryTableName}'''));
    return response.map((row) => InventoryModel.fromMap(row)).toList();
  }
}
