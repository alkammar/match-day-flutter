part of 'bloc.dart';

abstract class InvitePlayersEvent extends Equatable {
  const InvitePlayersEvent();

  @override
  List<Object> get props => [];
}

class FetchContacts extends InvitePlayersEvent {}

class SendInvitation extends InvitePlayersEvent {
  final MatchDay matchDay;

  SendInvitation(this.matchDay);

  @override
  List<Object> get props => [matchDay];
}
