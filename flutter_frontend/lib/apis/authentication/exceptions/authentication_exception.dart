class AuthenticationException implements Exception {
  String message = 'something\'s gone wrong :(';
  String? code;

  AuthenticationException({required this.code});
}

class EmailInUseException extends AuthenticationException {
  EmailInUseException({required super.code}) {
    super.message = 'Email in use';
  }
}

class InvalidEmailException extends AuthenticationException {
  InvalidEmailException({required super.code}) {
    super.message = 'Invalid email';
  }
}

class WeakPasswordException extends AuthenticationException {
  WeakPasswordException({required super.code}) {
    super.message = 'Weak password';
  }
}

class UserDisabledException extends AuthenticationException {
  UserDisabledException({required super.code}) {
    super.message = 'Account disabled';
  }
}

class UserNotFoundException extends AuthenticationException {
  UserNotFoundException({required super.code}) {
    super.message = 'Account not found';
  }
}

class WrongPasswordException extends AuthenticationException {
  WrongPasswordException({required super.code}) {
    super.message = 'Wrong password';
  }
}

class InvalidCredentialsException extends AuthenticationException {
  InvalidCredentialsException({required super.code}) {
    super.message = 'Invalid credentials';
  }
}

class OperationCanceledException extends AuthenticationException {
  OperationCanceledException({required super.code}) {
    super.message = 'Operation canceled';
  }
}

class UserNameUsedException extends AuthenticationException {
  UserNameUsedException({required super.code}) {
    super.message = 'User name used';
  }
}
