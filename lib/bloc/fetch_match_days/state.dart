part of 'bloc.dart';

class MatchDaysState extends Equatable {
  const MatchDaysState._({
    this.matchDays,
    this.error = '',
    this.started = false,
  });

  const MatchDaysState.unknown() : this._();

  const MatchDaysState.started() : this._(started: true);

  const MatchDaysState.fetched(List<MatchDay> matchDays) : this._(matchDays: matchDays);

  const MatchDaysState.error(String error) : this._(error: error);

  final List<MatchDay> matchDays;
  final String error;
  final bool started;

  @override
  List<Object> get props => [matchDays, error, started];
}
