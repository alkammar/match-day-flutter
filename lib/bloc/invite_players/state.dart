part of 'bloc.dart';

class InvitePlayersState extends Equatable {
  const InvitePlayersState({
    this.status = InvitePlayersStatus.uninitialized,
    this.error = '',
  });

  final InvitePlayersStatus status;
  final String error;

  InvitePlayersState copyWith({
    MatchDay copy,
    InvitePlayersStatus status,
    String error,
  }) {
    return InvitePlayersState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, error];
}

enum InvitePlayersStatus { uninitialized, fetching, fetched }
