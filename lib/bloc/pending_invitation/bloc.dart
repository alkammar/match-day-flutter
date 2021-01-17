import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/invitation.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/invitation_repository.dart';

part 'event.dart';
part 'state.dart';

class PendingInvitationBloc
    extends Bloc<PendingInvitationEvent, PendingInvitationState> {
  Uri _uri;
  final InvitationRepository _invitationRepository;

  PendingInvitationBloc({
    @required Uri uri,
    @required InvitationRepository invitationRepository,
  })  : _uri = uri,
        _invitationRepository = invitationRepository,
        super(const PendingInvitationState()) {
    add(Init(
      Invitation(
        id: _uri.queryParameters['iid'],
        matchDay:
            MatchDay(id: _uri.queryParameters['mdid'], name: 'well you know'),
      ),
    ));
  }

  @override
  Stream<PendingInvitationState> mapEventToState(
      PendingInvitationEvent event) async* {
    if (event is Init) {
      yield* _initInvitation(event);
    } else if (event is AskToJoinMatchDay) {
      yield* _askToJoin(event);
    }
  }

  Stream<PendingInvitationState> _initInvitation(Init event) async* {
    yield state.copyWith(
      status: PendingInvitationStatus.initialized,
      invitation: event.invitation,
    );
  }

  Stream<PendingInvitationState> _askToJoin(AskToJoinMatchDay event) async* {
    yield state.copyWith(status: PendingInvitationStatus.accepting);

    print('accepting invitation to ${state.invitation}');

    Invitation invitation = await _invitationRepository.addJoinRequest(
      state.invitation,
    );

    yield state.copyWith(status: PendingInvitationStatus.accepted);
  }
}
