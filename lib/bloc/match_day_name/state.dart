part of 'bloc.dart';

class MatchDayNameState extends Equatable {
  const MatchDayNameState._({
    this.name,
    this.error = '',
    this.fetching = false,
  });

  const MatchDayNameState.unknown() : this._();

  const MatchDayNameState.fetching() : this._(fetching: true);

  const MatchDayNameState.fetched(String name) : this._(name: name);

  final String name;
  final String error;
  final bool fetching;

  @override
  List<Object> get props => [name, error, fetching];
}
