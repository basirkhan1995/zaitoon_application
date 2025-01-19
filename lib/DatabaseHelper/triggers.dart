class Triggers {
  static String trigger = '''
  CREATE TRIGGER create_account_after_user
  AFTER INSERT ON users
  BEGIN
    INSERT INTO (user_id, account_balance, account_status)
    VALUES (new.user_id, 0.0, 'Active');
  END;
  ''';
}
