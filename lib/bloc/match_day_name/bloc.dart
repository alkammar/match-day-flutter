import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

class MatchDayNameBloc extends Bloc<MatchDayNameEvent, MatchDayNameState> {
  MatchDayNameBloc() : super(const MatchDayNameState.unknown());

  @override
  Stream<MatchDayNameState> mapEventToState(MatchDayNameEvent event) async* {
    if (event is Loading) {
      yield MatchDayNameState.fetching();
    } else if (event is Initialized) {
      yield MatchDayNameState.fetched(event.name);
    }
  }
}
