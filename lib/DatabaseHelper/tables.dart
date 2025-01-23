import 'package:zaitoon_invoice/DatabaseHelper/connection.dart';

class Tables {
  static String userTableName = "users";
  static String userRoleTableName = "userRole";
  static String currencyTableName = "currency";
  static String salesTableName = "sales";
  static String salesItemTableName = 'salesItems';
  static String productTableName = 'products';
  static String customerTableName = 'customers';
  static String stockTableName = 'stocks';
  static String paymentMethodTableName = 'paymentMethod';
  static String termsAndConditionTableName = 'termsAndCondition';
  static String productUnitTableName = 'productUnit';
  static String productCategoryTableName = 'productCategory';
  static String accountTableName = 'accounts';
  static String itemUnitTableName = 'itemUnit';

  static Future<void> userTable() async {
    final db = DatabaseHelper.db;
    final stm = db.prepare('''
  CREATE TABLE IF NOT EXISTS $userTableName(
  userId INTEGER PRIMARY KEY AUTOINCREMENT,
  fullName TEXT,
  businessName TEXT,
  mobile TEXT,
  telephone TEXT,
  address TEXT,
  email TEXT,
  companyLogo BLOB,
  username TEXT UNIQUE,
  password TEXT
  )''');
    stm.execute();
  }

  static String accountsTable = '''
  CREATE TABLE IF NOT EXISTS $accountTableName(
  accId INTEGER PRIMARY KEY AUTOINCREMENT,
  accountNumber TEXT UNIQUE NOT NULL,
  accountHolder INTEGER,
  accountCategory INTEGER,
  accCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  accUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
  )
  ''';

  static String userRoleTable = '''
  CREATE TABLE IF NOT EXISTS $userRoleTableName(
  userRoleId INTEGER PRIMARY KEY AUTOINCREMENT,
  userRoleName TEXT UNQIUE NOT NULL,
  roleId INTEGER
  )''';

  static String currencyTable = '''
  CREATE TABLE IF NOT EXISTS $currencyTableName(
  cId INTEGER PRIMARY KEY AUTOINCREMENT,
  currencyName TEXT,
  currencyCode TEXT,
  currencyLocalName TEXT,
  currencySymbol TEXT
  )''';

  static String salesTable = '''
  CREATE TABLE IF NOT EXISTS $salesTableName(
  invoiceId INTEGER PRIMARY KEY AUTOINCREMENT,
  invoiceNumber TEXT UNIQUE,
  dueDate TEXT DEFAULT CURRENT_TIMESTAMP,
  issueDate TEXT DEFAULT CURRENT_TIMESTAMP,
  invoiceStatus INTEGER,
  customer INTEGER,
  invoiceCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  invoiceUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  invoiceCurrency INTEGER,
  termsAndCondition INTEGER,

  FOREIGN KEY (termsAndCondition) REFERENCES $termsAndConditionTableName(tcId),
  FOREIGN KEY (invoiceCurrency) REFERENCES $currencyTableName(cId),
  FOREIGN KEY (client) REFERENCES $customerTableName(vendorId) ON DELETE CASCADE
  )''';

  static String salesItemTable = '''
  CREATE TABLE IF NOT EXISTS $salesItemTableName(
  salesItemId INTEGER PRIMARY KEY AUTOINCREMENT,
  productId INTEGER,
  salesId INTEGER,
  qty INTEGER,
  unitPrice REAL DEFAULT 0.00,
  paymentMethod INTEGER,
  stock INTEGER,
  FOREIGN KEY (stock) REFERENCES $stockTableName (stockId) ON DELETE CASCADE,
  FOREIGN KEY (paymentMethod) REFERENCES $paymentMethodTableName(paymentId) ON DELETE CASCADE,
  FOREIGN KEY (productId) REFERENCES $productTableName(productId) ON DELETE CASCADE,
  FOREIGN KEY (salesId) REFERENCES $salesTableName(salesId) ON DELETE CASCADE
  )''';

  static String productTable = '''
   CREATE TABLE IF NOT EXISTS $productTableName(
   productId INTEGER PRIMARY KEY AUTOINCREMENT,
   productName TEXT,
   productUnit INTEGER,
   buyRate REAL DEFAULT 0.00,
   description TEXT,
   FOREIGN KEY (productUnit) REFERENCES $productCategoryTableName(unitId) ON DELETE CASCADE 
   )''';

  static String productCategoryTable = '''
   CREATE TABLE IF NOT EXISTS $productCategoryTableName (
   categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
   categoryName TEXT UNIQUE
  )''';

  static String customerTable = '''
  CREATE TABLE IF NOT EXISTS $customerTableName(
  customerId INTEGER PRIMARY KEY AUTOINCREMENT,
  customerName TEXT,
  customerPhone TEXT,
  customerAddress TEXT,
  customerEmail TEXT,
  customerCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP
   )''';

  static String itemUnitTable = '''
  CREATE TABLE IF NOT EXISTS $itemUnitTableName (
   unitId INTEGER PRIMARY KEY AUTOINCREMENT,
   unitName TEXT UNIQUE,
   unitLocalName TEXT UNIQUE
  )''';

  static String paymentTable = '''
  CREATE TABLE IF NOT EXISTS payment(
  paymentId PRIMARY KEY AUTOINCREMENT,
  amount REAL DEFAULT 0.00,
  account INTEGER,
  paymentMethod INTEGER,
  FOREIGN KEY (account) REFERENCES $accountTableName(accountId),
  FOREIGN KEY (paymentMethod) REFERENCES $paymentMethodTableName(paymentMethodId),
  )''';

  static String paymentMethodTable = '''
  CREATE TABLE IF NOT EXISTS $paymentMethodTableName(
  paymentMethodId INTEGER PRIMARY KEY AUTOINCREMENT,
  paymentType TEXT
  )''';

  static String stockTable = '''
  CREATE TABLE IF NOT EXISTS $stockTableName(
  stockId INTEGER PRIMARY KEY AUTOINCREMENT,
  stockName TEXT
  )''';

  static String termsAndConditionTable = '''
  CREATE TABLE IF NOT EXISTS $termsAndConditionTableName(
  tcId INTEGER PRIMARY KEY AUTOINCREMENT,
  termTitle TEXT NOT NULL,
  termDescription TEXT NOT NULL
  )''';
}
