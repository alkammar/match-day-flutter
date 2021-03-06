part of 'bloc.dart';

class MatchDayAdminState extends Equatable {
  const MatchDayAdminState._({
    this.admin,
    this.error = '',
    this.fetching = false,
  });

  const MatchDayAdminState.unknown() : this._();

  const MatchDayAdminState.fetching() : this._(fetching: true);

  const MatchDayAdminState.fetched(Player admin) : this._(admin: admin);

  final Player admin;
  final String error;
  final bool fetching;

  @override
  List<Object> get props => [admin, error, fetching];
}
