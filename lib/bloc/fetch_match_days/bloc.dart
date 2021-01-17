import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/invitation.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/invitation_repository.dart';
import 'package:match_day/repo/matchday_repository.dart';

part 'event.dart';
part 'state.dart';

class FetchMatchDaysBloc extends Bloc<MatchDaysEvent, MatchDaysState> {
  final MatchDayRepository _matchDaysRepository;
  final InvitationRepository _invitationRepository;
  StreamSubscription<List<MatchDay>> _matchDaysStream;
  StreamSubscription<MatchDay> _invitationsStream;

  FetchMatchDaysBloc({
    @required MatchDayRepository matchDayRepository,
    @required InvitationRepository invitationRepository,
  })  : assert(matchDayRepository != null),
        _matchDaysRepository = matchDayRepository,
        _invitationRepository = invitationRepository,
        super(const MatchDaysState()) {
    // _invitationsStream =
    //     _invitationRepository.listenToUpdates((MatchDay matchDay) {
    //   return () {
    //     print('updates from listening');
    //     add(MatchDaysRequested());
    //   };
    // });
  }

  @override
  Stream<MatchDaysState> mapEventToState(MatchDaysEvent event) async* {
    if (event is MatchDaysRequested) {
      yield* _fetchMatchDays(event);
    } else if (event is MatchDaysUpdated) {
      yield state.copyWith(matchDays: event.matchDays);
    }
  }

  Stream<MatchDaysState> _fetchMatchDays(MatchDaysRequested event) async* {
    yield state.copyWith(status: MatchDaysStatus.fetching);

    try {
      List<MatchDay> matchDays = await _matchDaysRepository.fetchMatchDays();
      yield state.copyWith(
        status: MatchDaysStatus.complete,
        matchDays: matchDays,
      );

      _matchDaysStream?.cancel();
      _matchDaysStream = _matchDaysRepository.stream.listen((event) {
        add(MatchDaysUpdated(event));
      }, onError: (error) {
        print(' error from fetch match here $error');
      });

      print('no error from fetch match');

      List<Invitation> invitations =
          await _invitationRepository.fetchInvitations();
      // yield MatchDaysState.fetched(matchDays + invitations);
    } catch (e) {
      print('error from fetch match');
      yield state.copyWith(
        status: MatchDaysStatus.error,
        error: 'Something wrong happened $e',
      );
    }
  }

  @override
  Future<void> close() {
    // _invitationsStream.cancel();
    _matchDaysStream?.cancel();
    return super.close();
  }
}
