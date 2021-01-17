import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/user.dart';
import 'package:match_day/repo/authentication_repository.dart';

part 'event.dart';
part 'state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState()) {
    _authenticationRepository.stream.listen((user) {
      add(AuthenticationChanged(user));
    });
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationChanged) {
      yield* _initAuthentication(event);
    } else if (event is LogIn) {
      yield* _logIn(event);
    } else if (event is LogOut) {
      yield* _logOut(event);
    }
  }

  Stream<AuthenticationState> _initAuthentication(
      AuthenticationChanged event) async* {
    if (event.user == null) {
      yield state.copyWith(status: AuthenticationStatus.signedOut);
    } else {
      yield state.copyWith(status: AuthenticationStatus.signedIn);
    }
  }

  Stream<AuthenticationState> _logIn(LogIn event) async* {
    yield state.copyWith(status: AuthenticationStatus.signingIn);

    try {
      User user = await _authenticationRepository.signIn();
      yield state.copyWith(status: AuthenticationStatus.signedIn, user: user);
    } catch (error) {
      yield state.copyWith(
          status: AuthenticationStatus.error, error: error.toString());
    }
  }

  Stream<AuthenticationState> _logOut(LogOut event) async* {
    yield state.copyWith(status: AuthenticationStatus.signingOut);

    try {
      await _authenticationRepository.signOut();
      yield state.copyWith(status: AuthenticationStatus.signedOut, user: null);
    } catch (error) {
      yield state.copyWith(
          status: AuthenticationStatus.error, error: error.toString());
    }
  }
}
