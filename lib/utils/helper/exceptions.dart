class AppAuthExceptions implements Exception {

  final String code;

  AppAuthExceptions(this.code);
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already in-use. PLease use a different email.';
      case 'user-disabled':
        return 'The user corresponding to the given email has been disabled.';
      case 'user-not-found':
        return 'Invalid login credentials.';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try again.';
      case 'email-already-exists':
        return 'Email already exists. Please use a different email.';
      case 'invalid-credential':
        return 'Invalid login credentials.';
      default:
        print(code);
        return 'An unknown error occurred.';
    }
  }
}