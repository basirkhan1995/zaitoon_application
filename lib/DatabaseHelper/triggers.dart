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

  static String accountDepositTrigger = '''
  CREATE TRIGGER update_balance_after_deposit
  AFTER INSERT ON transactions
  FOR EACH ROW
  BEGIN
  -- Check if the transaction is a deposit
  IF NEW.transaction_type_id = 1 THEN
    -- Update the sender (and receiver) account's balance
    UPDATE accounts
    SET balance = balance + NEW.amount
    WHERE account_id = NEW.receiver_account_id;
     END IF;
   END;
 ''';

  static String accoutWithdrawTrigger = '''
  CREATE TRIGGER update_balance_after_withdrawal
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
  -- Check if the transaction is a withdrawal
  IF NEW.transaction_type_id = 2 THEN
    -- Update the sender account's balance (the one making the withdrawal)
    UPDATE accounts
    SET balance = balance - NEW.amount
    WHERE account_id = NEW.sender_account_id;
  END IF;
END;
  ''';

  static String inventoryTotalTrigger = '''

CREATE TRIGGER update_total_inventory
AFTER INSERT ON ${Tables.productInventoryTableName}
FOR EACH ROW
BEGIN
    -- Update the totalInventory for the specific product by calculating the total qty
    UPDATE ${Tables.productInventoryTableName}
    SET totalInventory = (
        SELECT SUM(
                   CASE
                       WHEN inventoryType = 'IN' THEN qty
                       WHEN inventoryType = 'OUT' THEN -qty
                       ELSE 0
                   END
               )
        FROM productInventoryTbl
        WHERE product = NEW.product
    )
    WHERE proInvId = NEW.proInvId;
END;

 ''';

  static String accountIdTrigger = '''
 -- Trigger to set starting point for new records in accountsTbl
CREATE TRIGGER set_account_id
BEFORE INSERT ON ${Tables.accountTableName}
FOR EACH ROW
BEGIN
  -- Check if the `sqlite_sequence` already exists for the accountsTbl
  -- and set it to 100, so the next insert will start from 100.
  UPDATE sqlite_sequence
  SET seq = 99
  WHERE name = ${Tables.accountTableName};
  
  -- Optionally: Add any other logic to handle specific insert actions
END;

 ''';
}
