class Tables {
  static String userTableName = "usersTbl";
  static String currencyTableName = "currenciesTbl";
  static String salesTableName = "salesTbl";
  static String salesItemTableName = 'salesItemsTbl';
  static String productTableName = 'productsTbl';
  static String inventoryTableName = 'inventoriesTbl';
  static String productInventoryTableName = 'productInventoryTbl';
  static String paymentMethodTableName = 'paymentMethodTbl';
  static String termsAndConditionTableName = 'termsAndConditionTbl';
  static String productUnitTableName = 'productUnitTbl';
  static String productCategoryTableName = 'productCategoryTbl';
  static String accountTableName = 'accountsTbl';
  static String itemUnitTableName = 'productUnitTbl';
  static String accountCategoryTableName = 'accountCategoryTbl';
  static String permissionTableName = 'permissionsTbl';
  static String rolePermissionTableName = 'rolePermissionTbl';
  static String userRoleTableName = "userRoleTbl";
  static String appMetadataTableName = 'appMetadataTbl';
  static String transactionsTableName = 'transactionsTbl';
  static String transactionTypeTableName = 'transactionTypeTbl';
  static String paymentTableName = 'paymentsTbl';
  static String exchangeRatesTableName = 'exchangeRatesTbl';

  //Tables
  static String metaDataTable = '''
  CREATE TABLE IF NOT EXISTS $appMetadataTableName (
  bId INTEGER PRIMARY KEY AUTOINCREMENT,
  owner INTEGER,
  businessName TEXT NOT NULL,
  companyLogo BLOB,
  address TEXT,
  mobile1 TEXT,
  mobile2 TEXT,
  email TEXT,
  FOREIGN KEY (owner) REFERENCES $accountTableName (accId) ON DELETE CASCADE
  )''';

  static String userTable = '''
  CREATE TABLE IF NOT EXISTS $userTableName(
  usrId INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE,
  password TEXT,
  userStatus INTEGER DEFAULT 1,
  businessId INTEGER NOT NULL,
  usrOwner INTEGER,
  userCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  userUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usrOwner) REFERENCES $accountTableName (accId) ON DELETE CASCADE
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
  accId INTEGER PRIMARY KEY,
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
  
  FOREIGN KEY (accountCategory) REFERENCES $accountCategoryTableName (accCategoryId) ON DELETE CASCADE,
  FOREIGN KEY (accountDefaultCurrency) REFERENCES $currencyTableName (currency_code) ON DELETE CASCADE
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
    FOREIGN KEY (base_currency_code) REFERENCES ${Tables.currencyTableName}(currency_code) ON DELETE CASCADE,
    FOREIGN KEY (target_currency_code) REFERENCES ${Tables.currencyTableName}(currency_code) ON DELETE CASCADE
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
  FOREIGN KEY (termsAndCondition) REFERENCES $termsAndConditionTableName(tcId) ON DELETE CASCADE,
  FOREIGN KEY (invoiceCurrency) REFERENCES $currencyTableName(currencyId) ON DELETE CASCADE,
  FOREIGN KEY (customer) REFERENCES $accountTableName(accId) ON DELETE CASCADE
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
  
  FOREIGN KEY (stock) REFERENCES $inventoryTableName (stockId) ON DELETE CASCADE,
  FOREIGN KEY (paymentMethod) REFERENCES $paymentMethodTableName(paymentId) ON DELETE CASCADE,
  FOREIGN KEY (productId) REFERENCES $productTableName(productId) ON DELETE CASCADE,
  FOREIGN KEY (salesId) REFERENCES $salesTableName(salesId) ON DELETE CASCADE
  )''';

  static String paymentTable = '''
  CREATE TABLE $paymentTableName (
  paymentId INTEGER PRIMARY KEY AUTOINCREMENT,
  transactionId INTEGER NOT NULL,
  method TEXT CHECK(paymentMethod IN ('Cash', 'Card')),
  payerId INTEGER NOT NULL,
  payeeId INTEGER NOT NULL,
  referenceNumber TEXT UNIQUE,
  
  FOREIGN KEY (transactionId) REFERENCES $transactionsTableName (transactionId) ON DELETE CASCADE,
  FOREIGN KEY (payerId) REFERENCES $accountTableName(accountId) ON DELETE CASCADE,
  FOREIGN KEY (payeeId) REFERENCES $accountTableName(accountId) ON DELETE CASCADE
  )''';

  //Not in Use
  static String paymentMethodTable = '''
  CREATE TABLE IF NOT EXISTS $paymentMethodTableName(
  paymentMethodId INTEGER PRIMARY KEY AUTOINCREMENT,
  paymentName TEXT UNIQUE NOT NULL,
  description TEXT,
  isActive INTEGER DEFAULT 1  
  )''';

  static String termsAndConditionTable = '''
  CREATE TABLE IF NOT EXISTS $termsAndConditionTableName(
  tcId INTEGER PRIMARY KEY AUTOINCREMENT,
  termTitle TEXT NOT NULL,
  termDescription TEXT NOT NULL
  )''';

  static String transactionsTable = '''
  CREATE TABLE IF NOT EXISTS $transactionsTableName (
  trnId INTEGER PRIMARY KEY AUTOINCREMENT,
  trnType INTEGER NOT NULL,
  trnNumber TEXT NOT NULL,
  amount REAL DEFAULT 0.0 NOT NULL,
  senderAccountId INTEGER,
  recipientAccountId INTEGER,
  trnStatus INTEGER,
  trnDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  trnUpdatedAt TEXT,
  FOREIGN KEY (senderAccountId) REFERENCES $accountTableName (accId) ON DELETE CASCADE,
  FOREIGN KEY (recipientAccountId) REFERENCES $accountTableName (accId) ON DELETE CASCADE,
  FOREIGN KEY (trnType) REFERENCES $transactionTypeTableName(trnTypeId) ON DELETE CASCADE
  )''';

  static String transactionTypeTable = '''
  CREATE TABLE IF NOT EXISTS $transactionTypeTableName (
  trnTypeId INTEGER PRIMARY KEY AUTOINCREMENT,
  trnTypeName INTEGER UNIQUE NOT NULL
  )''';

  static String productCategoryTable = '''
  CREATE TABLE IF NOT EXISTS $productCategoryTableName(
  pcId INTEGER PRIMARY KEY AUTOINCREMENT,
  pcName TEXT UNIQUE NOT NULL
  )''';

  static String productUnitTable = '''
  CREATE TABLE IF NOT EXISTS $itemUnitTableName (
  unitId INTEGER PRIMARY KEY AUTOINCREMENT,
  unitName TEXT UNIQUE
  )''';

  static String productsTable = '''
  CREATE TABLE IF NOT EXISTS $productTableName(
    productId INTEGER PRIMARY KEY AUTOINCREMENT,   
    productSerial INTEGER UNIQUE,                
    productName TEXT UNIQUE NOT NULL,             
    unit INTEGER,
    category INTEGER,
    FOREIGN KEY (category) REFERENCES $productCategoryTableName(pcId) ON DELETE CASCADE,
    FOREIGN KEY (unit) REFERENCES $productUnitTableName(unitId) ON DELETE CASCADE
  )''';

  static String inventoryTable = '''
  CREATE TABLE IF NOT EXISTS $inventoryTableName(
  invId INTEGER PRIMARY KEY AUTOINCREMENT,
  inventoryName TEXT UNIQUE NOT NULL
  )''';

  static String productInventoryTable = '''
  CREATE TABLE IF NOT EXISTS $productInventoryTableName(
  proInvId INTEGER PRIMARY KEY AUTOINCREMENT,
  product INTEGER,
  inventory INTEGER,
  buyPrice REAL CHECK(buyPrice >= 0),
  sellPrice REAL CHECK(sellPrice >= 0), 
  qty INTEGER DEFAULT 0 CHECK(qty >= 0 OR inventoryType = 'OUT'),
  inventoryType TEXT DEFAULT 'IN' CHECK(inventoryType IN ('IN', 'OUT')),
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (inventory) REFERENCES $inventoryTableName(invId) ON DELETE CASCADE,
  FOREIGN KEY (product) REFERENCES $productTableName(productId) ON DELETE CASCADE
  )''';
}
