import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class DefaultValues {

  static String defaultRoles = '''
  INSERT INTO ${Tables.userRoleTableName} (roleName) VALUES
  ('admin'),
  ('manager')
  ''';

  static String defaultAccountCategory = '''
  
  INSERT INTO ${Tables.accountCategoryTableName} (accCategoryId, accCategoryName) VALUES
  (1,'User'),
  (2,'Bank'),
  (3,'Customer'),
  (4,'Saraf'),
  (5,'Expense'),
  (6,'Company'),
  (7,'System'),
  (8,'Admin')
  ''';
}
