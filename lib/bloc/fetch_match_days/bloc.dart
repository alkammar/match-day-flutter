import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/invitation_repository.dart';
import 'package:match_day/repo/matchday_repository.dart';

part 'event.dart';
part 'state.dart';

class FetchMatchDaysBloc extends Bloc<MatchDaysEvent, MatchDaysState> {
  final MatchDayRepository _matchDaysRepository;
  final InvitationRepository _invitationRepository;
  StreamSubscription<MatchDay> _matchDaysStream;
  StreamSubscription<MatchDay> _invitationsStream;

  FetchMatchDaysBloc({
    @required MatchDayRepository matchDayRepository,
    @required InvitationRepository invitationRepository,
  })  : assert(matchDayRepository != null),
        _matchDaysRepository = matchDayRepository,
        _invitationRepository = invitationRepository,
        super(const MatchDaysState.unknown()) {
    _matchDaysStream = _matchDaysRepository.listenToUpdates((MatchDay matchDay) {
      return {add(FetchMatchDays())};
    });
    _invitationsStream = _invitationRepository.listenToUpdates((MatchDay matchDay) {
      return {add(FetchMatchDays())};
    });
  }

  @override
  Stream<MatchDaysState> mapEventToState(MatchDaysEvent event) async* {
    if (event is FetchMatchDays) {
      yield MatchDaysState.started();

      try {
        List<MatchDay> matchDays = await _matchDaysRepository.fetchMatchDays();
        yield MatchDaysState.fetched(matchDays);
        List<MatchDay> invitations = await _invitationRepository.fetchMatchDays();
        yield MatchDaysState.fetched(matchDays + invitations);
      } catch (e) {
        yield MatchDaysState.error('Something wrong happened $e');
      }
    }
  }

  @override
  Future<void> close() {
    _matchDaysStream.cancel();
    _invitationsStream.cancel();
    return super.close();
  }
}
