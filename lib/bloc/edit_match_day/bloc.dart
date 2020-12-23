import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/matchday_repository.dart';

part 'event.dart';
part 'state.dart';

class EditMatchDayBloc extends Bloc<EditMatchDayEvent, EditMatchDayState> {
  MatchDay _matchDay;
  final MatchDayRepository _matchDayRepository;

  MatchDay _editedMatchDay;

  EditMatchDayBloc({
    @required MatchDay matchDay,
    @required MatchDayRepository matchDayRepository,
  })
      : _matchDayRepository = matchDayRepository,
        super(const EditMatchDayState.unknown()) {

    if (matchDay != null) {
      add(LoadMatchDay(matchDay));
    }
  }

  @override
  Stream<EditMatchDayState> mapEventToState(EditMatchDayEvent event) async* {
    if (event is LoadMatchDay) {
      yield* _initializeMatchDay(event);
    } else if (event is EditName) {
      yield* _editName(event);
    } else if (event is SubmitEdits) {
      yield* _updateMatchDay();
    }
  }

  Stream<EditMatchDayState> _initializeMatchDay(LoadMatchDay event) async* {
    _matchDay = event.matchDay;
    _editedMatchDay = _matchDay.clone();

    yield EditMatchDayState.initialized(_matchDay);
  }

  Stream<EditMatchDayState> _editName(EditName event) async* {
    _editedMatchDay.name = event.name;
    if (_matchDay != _editedMatchDay) {
      yield EditMatchDayState.edited(_matchDay, _editedMatchDay);
    } else {
      yield EditMatchDayState.unedited(_matchDay);
    }
  }

  Stream<EditMatchDayState> _updateMatchDay() async* {
    yield EditMatchDayState.submitting();
    await _matchDayRepository.update(_matchDay, _editedMatchDay);
    yield EditMatchDayState.submitted();
  }
}
