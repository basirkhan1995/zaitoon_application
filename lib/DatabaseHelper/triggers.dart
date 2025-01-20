import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class Triggers {
  static String trigger = '''
  CREATE TRIGGER create_account_after_user
  AFTER INSERT ON users
  BEGIN
    INSERT INTO (userId, account_balance, account_status)
    VALUES (new.user_id, 0.0, 'Active');
  END;
  ''';

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
}
