class DefaultValues {
  static String defaultUserRoles = '''
  INSERT INTO userRoles (roleName, description) VALUES 
  ('Admin', 'Full access to the system'),
  ('Editor', 'Can edit content'),
  ('Viewer', 'Can view content only')
  ''';
}
