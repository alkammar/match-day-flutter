part of 'bloc.dart';

abstract class PendingInvitationEvent extends Equatable {
  const PendingInvitationEvent();

  @override
  List<Object> get props => [];
}

class InitInvitation extends PendingInvitationEvent {
  final MatchDay invitation;

  InitInvitation(this.invitation);

  @override
  List<Object> get props => [invitation];
}

class AskToJoinMatchDay extends PendingInvitationEvent {}

class DiscardMatchDay extends PendingInvitationEvent {}
