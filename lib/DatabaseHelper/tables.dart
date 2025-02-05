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
  usrId INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE,
  password TEXT,
  userStatus INTEGER,
  businessId INTEGER NOT NULL,
  createdBy INTEGER,
  userCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  userUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (businessId) REFERENCES $appMetadataTableName (bId) ON DELETE CASCADE
  )''';

  static String rolesPermissionsTable = '''
  CREATE TABLE IF NOT EXISTS $rolePermissionTableName (
  rolePermissionId INTEGER PRIMARY KEY AUTOINCREMENT,
  permission INTEGER,
  user INTEGER,

  FOREIGN KEY (permission) REFERENCES $permissionTableName(permissionId) ON DELETE CASCADE,
  FOREIGN KEY (user) REFERENCES $userTableName(usrId) ON DELETE CASCADE
  )''';

  static String permissionsTable = '''
  CREATE TABLE IF NOT EXISTS $permissionTableName (
  permissionId INTEGER PRIMARY KEY AUTOINCREMENT,

  viewDatabaseSettings INTEGER,
  viewCurrencySettings INTEGER,

  viewAccounts INTEGER,
  createAccount INTEGER,
  updateAccount INTEGER,
  deleteAccount INTEGER,
  
  viewExchange INTEGER,
  createExchange INTEGER,
  updateExchange INTEGER,
  deleteExchange INTEGER,

  viewTransfer INTEGER,
  createTransfer INTEGER,
  updateTransfer INTEGER,
  deleteTransfer INTEGER,

  viewTransaction INTEGER,
  createTransaction INTEGER,
  updateTransaction INTEGER,
  deleteTransaction INTEGER
  )''';

  static String accountCategoryTable = '''
  CREATE TABLE IF NOT EXISTS $accountCategoryTableName(
  accCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
  accCategoryName TEXT
  )''';

  static String accountsTable = '''
  CREATE TABLE IF NOT EXISTS $accountTableName(
  accId INTEGER PRIMARY KEY AUTOINCREMENT,
  accountNumber TEXT UNIQUE,
  accountName TEXT NOT NULL,
  mobile TEXT,
  address TEXT,
  email TEXT,
  accountCategory INTEGER,
  createdBy INTEGER,
  accountDefaultCurrency TEXT,
  accCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  accUpdatedAt TEXT,
  
  FOREIGN KEY (accountCategory) REFERENCES $accountCategoryTableName (accCategoryId),
  FOREIGN KEY (accountDefaultCurrency) REFERENCES $currencyTableName (currency_code)
  )''';

  static String currencyTable = '''
  
  CREATE TABLE $currencyTableName (
    currency_id INTEGER PRIMARY KEY AUTOINCREMENT,
    currency_code TEXT NOT NULL UNIQUE,
    currency_name TEXT NOT NULL,      
    symbol TEXT,
    isDefault INTEGER DEFAULT 0 CHECK (isDefault IN (0, 1))                        
  )''';

  static String currencyExchangeRateTable = '''
 CREATE TABLE $exchangeRatesTableName (
    exchange_rate_id INTEGER PRIMARY KEY,
    base_currency_code TEXT,
    target_currency_code TEXT,
    rate REAL NOT NULL,                  
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (base_currency_code) REFERENCES ${Tables.currencyTableName}(currency_code),
    FOREIGN KEY (target_currency_code) REFERENCES ${Tables.currencyTableName}(currency_code)
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
