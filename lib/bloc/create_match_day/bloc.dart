import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/bloc/edit_match_day/bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/matchday_repository.dart';

part 'event.dart';
part 'state.dart';

class CreateMatchDayBloc extends Bloc<CreateMatchDayEvent, CreateMatchDayState> {
  final MatchDayRepository _matchDaysRepository;
  EditMatchDayBloc _editMatchDayBloc;

  CreateMatchDayBloc({
    @required MatchDayRepository matchDayRepository,
    @required EditMatchDayBloc editMatchDayBloc,
  })  : _matchDaysRepository = matchDayRepository,
        _editMatchDayBloc = editMatchDayBloc,
        super(const CreateMatchDayState.unknown());

  @override
  Stream<CreateMatchDayState> mapEventToState(CreateMatchDayEvent event) async* {
    if (event is CreateMatchDay) {
      yield CreateMatchDayState.started();
      MatchDay matchDay = await _matchDaysRepository.createMatchDay();

      yield CreateMatchDayState.created(matchDay);

      _editMatchDayBloc.add(LoadMatchDay(matchDay));
    }
  }

  @override
  Future<void> close() {
    _editMatchDayBloc.close();
    return super.close();
  }
}
