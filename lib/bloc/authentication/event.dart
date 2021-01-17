part of 'bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationChanged extends AuthenticationEvent {
  final User user;

  const AuthenticationChanged(this.user);

  @override
  List<Object> get props => [];
}

class LogOut extends AuthenticationEvent {}

class LogIn extends AuthenticationEvent {}
