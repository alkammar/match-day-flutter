import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/matchday_repository.dart';

part 'event.dart';

part 'state.dart';

class FetchMatchDaysBloc extends Bloc<MatchDaysEvent, MatchDaysState> {
  final MatchDayRepository _matchDaysRepository;
  StreamSubscription<MatchDay> _streamSubscription;

  FetchMatchDaysBloc({
    @required MatchDayRepository matchDayRepository,
  })  : assert(matchDayRepository != null),
        _matchDaysRepository = matchDayRepository,
        super(const MatchDaysState.unknown()) {

    debugPrint('initialize fetch');
    _streamSubscription = _matchDaysRepository.listenToUpdates((MatchDay matchDay) {
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
      } catch (e) {
        yield MatchDaysState.error('Something wrong happened $e');
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
