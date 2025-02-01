import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class DefaultValues {
  static String defaultUserRoles = '''
  INSERT INTO ${Tables.userRoleTableName} (roleId, roleName, roleLanguageCode) VALUES 
  (1,'Admin','en'),
  (2,'User','en'),

  (3,'مدیر','fa'),
  (4, 'یوزر' , 'fa'),

  (5, 'مدیر','ar'),
  (6, 'یوزر', 'ar') ''';

  static String defaultAccountCategory = '''
  INSERT INTO ${Tables.accountCategoryTableName} (accCategoryId, accCategoryName, languageCode) VALUES
  (1,'User','en'),
  (2,'Bank','en'),
  (3,'Customer','en'),
  (4,'Saraf','en'),
  (5,'Expense','en'),
  (6,'Company','en'),
  (7,'System','en'),
  
  (8,'یوزر','fa'),
  (9,'بانک','fa'),
  (10,'مشتری','fa'),
  (11,'صراف','fa'),
  (12,'مصرف','fa'),
  (13,'شرکت','fa'),
  (14,'سیستم','fa'),

  (15, 'یوزر' , 'ar'),
  (16, 'بانک' , 'ar'),
  (17, 'پیرودونکی','ar'),
  (18, 'صراف' , 'ar'),
  (19, 'مصرف' , 'ar'),
  (20, 'شرکت' , 'ar'),
  (21, 'سیستم' , 'ar')
   ''';
}
