class Tables {
  static String userTableName = "users";
  static String userRoleTableName = "userRole";
  static String currencyTableName = "currency";
  static String salesTableName = "sales";
  static String salesItemTableName = 'salesItem';
  static String estimateTableName = 'estimate';
  static String productTableName = 'products';
  static String customerTableName = 'customers';
  static String stockTableName = 'stocks';
  static String paymentMethodTableName = 'paymentMethod';
  static String termsAndConditionTableName = 'termsAndCondition';
  static String productUnitTableName = 'productUnit';
  static String productCategoryTableName = 'productCategory';

  static String invoiceNumberTrigger = '''
  CREATE TRIGGER generate_invoice_number
  AFTER INSERT ON $salesTableName
  FOR EACH ROW
  BEGIN
  UPDATE $salesTableName
  SET invoiceNumber = 'INV' || printf('%05d', NEW.invoiceId)
  WHERE invoiceId = NEW.invoiceId;
  END;
  ''';

  static String termsAndConditionTable = '''
  CREATE TABLE IF NOT EXISTS $termsAndConditionTableName(
  tcId INTEGER PRIMARY KEY AUTOINCREMENT,
  termTitle TEXT NOT NULL,
  termDescription TEXT NOT NULL
  )''';

  static String userTable = '''
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
  password TEXT,
  )''';

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

  static String invoiceTable = '''
  CREATE TABLE IF NOT EXISTS $salesTableName(
  invoiceId INTEGER PRIMARY KEY AUTOINCREMENT,
  invoiceNumber TEXT UNIQUE,
  dueDate TEXT DEFAULT CURRENT_TIMESTAMP,
  issueDate TEXT DEFAULT CURRENT_TIMESTAMP,
  invoiceStatus INTEGER,
  client INTEGER,
  invoiceCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  invoiceUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  invoiceCurrency INTEGER,
  termsAndCondition INTEGER,
  signature BLOB,

  FOREIGN KEY (termsAndCondition) REFERENCES $termsAndConditionTableName(tcId),
  FOREIGN KEY (invoiceCurrency) REFERENCES $currencyTableName(cId),
  FOREIGN KEY (client) REFERENCES $customerTableName(vendorId) ON DELETE CASCADE
  )''';

  static String invoiceDetailsTable = '''
    CREATE TABLE IF NOT EXISTS $salesItemTableName(
    salesItemId INTEGER PRIMARY KEY AUTOINCREMENT,
    salesItemId INTEGER,
    invId INTEGER,
    qty INTEGER,
    unitPrice REAL DEFAULT 0.0,
    FOREIGN KEY (invoiceItemId) REFERENCES $productTableName(itemId) ON DELETE CASCADE,
    FOREIGN KEY (invID) REFERENCES $salesTableName(invoiceId) ON DELETE CASCADE
    )''';

  static String productTable = '''
  CREATE TABLE IF NOT EXISTS $productTableName(
   itemId INTEGER PRIMARY KEY AUTOINCREMENT,
   itemName TEXT,
   itemUnit INTEGER,
   buyRate REAL DEFAULT 0.0,
   description TEXT,
   FOREIGN KEY (itemUnit) REFERENCES $productCategoryTableName(categoryId) ON DELETE CASCADE 
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

  static String productCategoryTable = '''
  CREATE TABLE IF NOT EXISTS $productCategoryTableName (
   unitId INTEGER PRIMARY KEY AUTOINCREMENT,
   unitAbbreviation TEXT UNIQUE,
   unitName TEXT UNIQUE,
   unitLocalName TEXT UNIQUE
  )''';
}
