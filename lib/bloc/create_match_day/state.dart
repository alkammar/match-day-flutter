part of 'bloc.dart';

class CreateMatchDayState extends Equatable {

  const CreateMatchDayState._({
    this.matchDay,
    this.error = '',
    this.started = false,
  });

  const CreateMatchDayState.unknown() : this._();

  const CreateMatchDayState.started() : this._(started: true);

  const CreateMatchDayState.created(MatchDay matchDay) : this._(matchDay: matchDay);

  final MatchDay matchDay;
  final String error;
  final bool started;

  @override
  List<Object> get props => [matchDay, error, started];
}
