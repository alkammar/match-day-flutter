part of 'bloc.dart';

abstract class InvitePlayersEvent extends Equatable {
  const InvitePlayersEvent();

  @override
  List<Object> get props => [];
}

class FetchContacts extends InvitePlayersEvent {}

class SendInvitation extends InvitePlayersEvent {
  final String number;

  SendInvitation(this.number);

  @override
  List<Object> get props => [number];
}
