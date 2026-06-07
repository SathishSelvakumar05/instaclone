import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/AuthRepository.dart';
import 'AuthState.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _repository.login(email: email, password: password);
      if (user == null) {
        emit(AuthFailure('Account not found. Please register first.'));
      } else {
        emit(AuthSuccess(user));
      }
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException [login] code: ${e.code} | message: ${e.message}');
      emit(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      log('Login error: $e');
      emit(AuthFailure('Login failed. Please try again.'));
    }
  }

  Future<void> register(String email, String username, String password) async {
    emit(AuthLoading());
    try {
      final user = await _repository.register(
        email: email,
        username: username,
        password: password,
      );
      emit(AuthRegistered(user));
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException [register] code: ${e.code} | message: ${e.message}');
      emit(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      log('Register error: $e');
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email address already registered';
      case 'user-not-found':
        return 'No account found. Please register first.';
      case 'wrong-password':
        return 'Invalid email or password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'invalid-email':
        return 'Enter a valid email address';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled. Enable it in Firebase Console → Authentication → Sign-in method.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'channel-error':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Error ($code). Check the console for details.';
    }
  }

  void reset() => emit(AuthInitial());
}
