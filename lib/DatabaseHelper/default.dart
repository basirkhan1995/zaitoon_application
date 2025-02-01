import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class DefaultValues {
  static String defaultUserRoles = '''
  INSERT INTO ${Tables.userRoleTableName} (roleName) VALUES 
  ('admin'),
  ('editor'),
  ('viewer')''';

  static String defaultAccountCategory = '''
  INSERT INTO ${Tables.accountCategoryTableName} () VALUES
  ('user'),
  (),
  (),
  (),
  (),
  (),

  ''';
}
