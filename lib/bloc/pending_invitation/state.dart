part of 'bloc.dart';

class PendingInvitationState extends Equatable {
  const PendingInvitationState({
    this.status = PendingInvitationStatus.uninitialized,
    this.invitation,
    this.error = '',
  });

  final PendingInvitationStatus status;
  final Invitation invitation;
  final String error;

  PendingInvitationState copyWith({
    PendingInvitationStatus status,
    MatchDay invitation,
    String error,
  }) {
    return PendingInvitationState(
      status: status ?? this.status,
      invitation: invitation ?? this.invitation,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, invitation, error];
}

enum PendingInvitationStatus { uninitialized, initialized, accepting, declining, accepted, declined, error }
