import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/matchday_repository.dart';

part 'event.dart';
part 'state.dart';

class EditMatchDayBloc extends Bloc<EditMatchDayEvent, EditMatchDayState> {
  // MatchDay _matchDay;
  final MatchDayRepository _matchDayRepository;

  // MatchDay _editedMatchDay;

  EditMatchDayBloc({
    @required MatchDay matchDay,
    @required MatchDayRepository matchDayRepository,
  })  : _matchDayRepository = matchDayRepository,
        super(EditMatchDayState(original: matchDay));

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
    yield state.copyWith(
        status: EditStatus.unedited,
        copy: state.original ?? MatchDay(name: ''));
  }

  Stream<EditMatchDayState> _editName(EditName event) async* {
    yield state.copyWith(copy: state.copy.copyWith(name: event.name));
    if (state.original != state.copy) {
      yield state.copyWith(status: EditStatus.edited);
    } else {
      yield state.copyWith(status: EditStatus.unedited);
    }
  }

  Stream<EditMatchDayState> _updateMatchDay() async* {
    yield state.copyWith(status: EditStatus.submitting);
    if (state.original == null) {
      await _matchDayRepository.createMatchDay(state.copy);
    } else {
      await _matchDayRepository.updateMatchDay(state.copy);
    }
    yield state.copyWith(status: EditStatus.complete);
  }
}
