import '../Model/InstaUserModel.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final InstaUserModel user;
  AuthSuccess(this.user);
}

class AuthRegistered extends AuthState {
  final InstaUserModel user;
  AuthRegistered(this.user);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
