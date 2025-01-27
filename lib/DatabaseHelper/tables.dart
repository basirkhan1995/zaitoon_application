class Tables {
  static String userTableName = "users";
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
  static String accountCategoryTableName = 'accountCategory';
  static String permissionTableName = 'permissions';
  static String rolePermissionTableName = 'rolePermission';
  static String userRoleTableName = "userRole";
  static String appMetadataTableName = 'appMetadata';
  static String transactionsTableName = 'transactions';
  static String transactionTypeTableName = 'transactionType';
  static String paymentTableName = 'payments';
  static String exchangeRatesTableName = 'exchangeRates';

  //Tables
  static String metaDataTable = '''
  CREATE TABLE IF NOT EXISTS $appMetadataTableName (
  bId INTEGER PRIMARY KEY AUTOINCREMENT,
  ownerName TEXT NOT NULL,
  businessName TEXT NOT NULL,
  companyLogo BLOB,
  address TEXT,
  mobile1 TEXT,
  mobile2 TEXT,
  email TEXT
  )''';

  static String userTable = '''
  CREATE TABLE IF NOT EXISTS $userTableName(
  userId INTEGER PRIMARY KEY AUTOINCREMENT,
  userRoleId INTEGER,
  username TEXT UNIQUE,
  password TEXT,
  userStatus INTEGER,
  businessId INTEGER NOT NULL,
  
  userCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  userUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (businessId) REFERENCES $appMetadataTableName (bId) ON DELETE CASCADE,
  FOREIGN KEY (userRoleId) REFERENCES $userRoleTableName(roleId)
  )''';

  static String userRoleTable = '''
  CREATE TABLE IF NOT EXISTS $userRoleTableName (
  roleId INTEGER PRIMARY KEY AUTOINCREMENT,
  roleName TEXT UNIQUE NOT NULL
  )''';

  static String permissionsTable = '''
  CREATE TABLE IF NOT EXISTS $permissionTableName (
  permissionId INTEGER PRIMARY KEY AUTOINCREMENT,
  permissionName TEXT UNIQUE NOT NULL
  )''';

  static String rolesPermissionsTable = '''
  CREATE TABLE $rolePermissionTableName (
  rolePermissionId INTEGER PRIMARY KEY AUTOINCREMENT,
  roleId INTEGER NOT NULL,
  permissionId INTEGER NOT NULL,
  FOREIGN KEY(roleId) REFERENCES $userRoleTableName(roleId),
  FOREIGN KEY(permissionId) REFERENCES $permissionTableName(permissionId)
  );
  ''';

  static String accountCategoryTable = '''
  CREATE TABLE IF NOT EXISTS $accountCategoryTableName(
  accCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
  accCategoryName TEXT UNIQUE NOT NULL
  )''';

  static String accountsTable = '''
  CREATE TABLE IF NOT EXISTS $accountTableName(
  accId INTEGER PRIMARY KEY AUTOINCREMENT,
  accountNumber TEXT UNIQUE NOT NULL,
  accountHolder INTEGER,
  accountCategory INTEGER,
  accCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  accUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (accountCategory) REFERENCES $accountCategoryTableName (id)
  )''';

  static String currencyTable = '''
  CREATE TABLE IF NOT EXISTS $currencyTableName (
  currencyId INTEGER PRIMARY KEY AUTOINCREMENT,
  currencyCode TEXT NOT NULL UNIQUE,           
  currencyName TEXT NOT NULL,                 
  symbol TEXT,                             
  decimalPlaces INTEGER DEFAULT 2 CHECK (decimalPlaces >= 0),
  isDefault INTEGER DEFAULT 0 CHECK (isDefault IN (0, 1)),
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP 
  )''';

  static String currencyExchangeRateTable = '''
  CREATE TABLE IF NOT EXISTS $exchangeRatesTableName (
  exchangeId INTEGER PRIMARY KEY AUTOINCREMENT,
  baseCurrencyCode TEXT NOT NULL,               
  targetCurrencyCode TEXT NOT NULL,              
  rate1 REAL NOT NULL CHECK (rate1 > 0),        
  rate2 REAL NOT NULL CHECK (rate2 > 0),      
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,  
  UNIQUE (baseCurrencyCode, targetCurrencyCode
  )''';

  static String salesTable = '''
  CREATE TABLE IF NOT EXISTS $salesTableName(
  invoiceId INTEGER PRIMARY KEY AUTOINCREMENT,
  invoiceNumber TEXT UNIQUE,
  dueDate TEXT DEFAULT CURRENT_TIMESTAMP,
  issueDate TEXT DEFAULT CURRENT_TIMESTAMP,
  invoiceStatus INTEGER,
  customer INTEGER,
  invoiceCurrency INTEGER,
  termsAndCondition INTEGER,
  
  invoiceCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  invoiceUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (termsAndCondition) REFERENCES $termsAndConditionTableName(tcId),
  FOREIGN KEY (invoiceCurrency) REFERENCES $currencyTableName(currencyId),
  FOREIGN KEY (customer) REFERENCES $customerTableName(clientId) ON DELETE CASCADE
  )''';

  static String salesItemsTable = '''
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
  customerCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
  )''';

  static String itemUnitTable = '''
  CREATE TABLE IF NOT EXISTS $itemUnitTableName (
  unitId INTEGER PRIMARY KEY AUTOINCREMENT,
  unitName TEXT UNIQUE
  )''';

  static String paymentTable = '''
  CREATE TABLE $paymentTableName (
  paymentId INTEGER PRIMARY KEY AUTOINCREMENT,
  transactionId INTEGER NOT NULL,
  method TEXT CHECK(paymentMethod IN ('Cash', 'Card')),
  payerId INTEGER NOT NULL,
  payeeId INTEGER NOT NULL,
  referenceNumber TEXT UNIQUE,
  
  FOREIGN KEY (transactionId) REFERENCES $transactionsTableName (transactionId),
  FOREIGN KEY (payerId) REFERENCES $accountTableName(accountId),
  FOREIGN KEY (payeeId) REFERENCES $accountTableName(accountId)
  )''';

  //Not in Use
  static String paymentMethodTable = '''
  CREATE TABLE IF NOT EXISTS $paymentMethodTableName(
  paymentMethodId INTEGER PRIMARY KEY AUTOINCREMENT,
  paymentName TEXT UNIQUE NOT NULL,
  description TEXT,
  isActive INTEGER DEFAULT 1  
  )''';

  static String stockTable = '''
  CREATE TABLE IF NOT EXISTS $stockTableName(
  stockId INTEGER PRIMARY KEY AUTOINCREMENT,
  stockName TEXT UNIQUE
  )''';

  static String termsAndConditionTable = '''
  CREATE TABLE IF NOT EXISTS $termsAndConditionTableName(
  tcId INTEGER PRIMARY KEY AUTOINCREMENT,
  termTitle TEXT NOT NULL,
  termDescription TEXT NOT NULL
  )''';

  static String transactionsTable = '''
  CREATE TABLE IF NOT EXISTS $transactionsTableName (
  transactionId INTEGER PRIMARY KEY AUTOINCREMENT,
  transactionType INTEGER NOT NULL, -- e.g., "sale", "refund"
  transactionNumber TEXT NOT NULL,
  amount REAL DEFAULT 0.0 NOT NULL,
  senderAccountId INTEGER,
  recipientAccountId INTEGER,
  transactionStatus INTEGER,
  transactionDate DATETIME DEFAULT CURRENT_TIMESTAMP
  )''';
}
