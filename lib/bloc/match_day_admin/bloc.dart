import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/admin.dart';

part 'event.dart';
part 'state.dart';

class MatchDayAdminBloc extends Bloc<MatchDayAdminEvent, MatchDayAdminState> {
  MatchDayAdminBloc() : super(const MatchDayAdminState.unknown());

  @override
  Stream<MatchDayAdminState> mapEventToState(MatchDayAdminEvent event) async* {
    if (event is Assigning) {
      yield MatchDayAdminState.fetching();
    } else if (event is Ready) {
      yield MatchDayAdminState.fetched(event.admin);
    }
  }
}
