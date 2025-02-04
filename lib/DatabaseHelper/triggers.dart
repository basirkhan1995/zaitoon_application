import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class Triggers {
  static String invoiceNumberTrigger = '''
  CREATE TRIGGER generate_invoice_number
  AFTER INSERT ON ${Tables.salesTableName}
  FOR EACH ROW
  BEGIN
  UPDATE ${Tables.salesTableName}
  SET invoiceNumber = 'INV' || printf('%05d', NEW.invoiceId)
  WHERE invoiceId = NEW.invoiceId;
  END;
  ''';

  static String accountNumberTrigger = '''
  CREATE TRIGGER set_accountNumber
  AFTER INSERT ON ${Tables.accountTableName}
  FOR EACH ROW
  BEGIN
    UPDATE ${Tables.accountTableName}
     SET accountNumber = 'ACC' || strftime('%Y%m%d', NEW.accCreatedAt) || printf('%04d', NEW.accId)
    WHERE accId = NEW.accId;
  END;
  ''';
}
