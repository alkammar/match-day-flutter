import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/matchday_repository.dart';

part 'event.dart';
part 'state.dart';

class EditMatchDayBloc extends Bloc<EditMatchDayEvent, EditMatchDayState> {
  final MatchDayRepository _matchDayRepository;

  EditMatchDayBloc({
    @required MatchDay matchDay,
    @required MatchDayRepository matchDayRepository,
  })  : _matchDayRepository = matchDayRepository,
        super(EditMatchDayState(
            status: EditStatus.unedited,
            original: matchDay,
            copy: matchDay ?? MatchDay(name: '')));

  @override
  Stream<EditMatchDayState> mapEventToState(EditMatchDayEvent event) async* {
    if (event is EditName) {
      yield* _editName(event);
    } else if (event is SubmitEdits) {
      yield* _updateMatchDay();
    }
  }

  Stream<EditMatchDayState> _editName(EditName event) async* {
    var copyWith = state.copy.copyWith(name: event.name);
    print('edited name ${copyWith.name}');
    yield state.copyWith(copy: copyWith);
    print('edited name sate ${state.copy.name}');
    if (state.original != state.copy) {
      print('edited ${state.copy}');
      yield state.copyWith(
          status: EditStatus.edited,
          copy: state.copy.copyWith(name: event.name));
    } else {
      yield state.copyWith(
          status: EditStatus.unedited,
          copy: state.copy.copyWith(name: event.name));
    }
  }

  Stream<EditMatchDayState> _updateMatchDay() async* {
    yield state.copyWith(status: EditStatus.submitting);
    if (state.original == null) {
      print('creating ${state.copy}');
      await _matchDayRepository.createMatchDay(state.copy);
    } else {
      await _matchDayRepository.updateMatchDay(state.copy);
    }
    yield state.copyWith(status: EditStatus.complete);
  }
}
