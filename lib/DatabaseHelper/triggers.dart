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
  CREATE TRIGGER auto_account_number
  AFTER INSERT ON ${Tables.accountTableName}
  FOR EACH ROW
  BEGIN
  UPDATE ${Tables.accountTableName}
  SET accountNumber = (SELECT COALESCE(MAX(accountNumber), 99) + 1 FROM ${Tables.accountTableName})
  WHERE accId = NEW.accId;
  END;
  ''';
}
