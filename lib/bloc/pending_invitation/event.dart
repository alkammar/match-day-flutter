part of 'bloc.dart';

abstract class PendingInvitationEvent extends Equatable {
  const PendingInvitationEvent();

  @override
  List<Object> get props => [];
}

class Init extends PendingInvitationEvent {
  final Invitation invitation;

  Init(this.invitation);

  @override
  List<Object> get props => [invitation];
}

class AskToJoinMatchDay extends PendingInvitationEvent {}

class DiscardMatchDay extends PendingInvitationEvent {}
