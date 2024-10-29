part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateLoaded extends AuthState {}

class AuthStateError extends AuthState {
  final String message;

  AuthStateError({required this.message});
}
