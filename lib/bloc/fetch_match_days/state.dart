part of 'bloc.dart';

class MatchDaysState extends Equatable {
  const MatchDaysState({
    this.status = MatchDaysStatus.uninitialized,
    this.matchDays,
    this.error = '',
  });

  MatchDaysState copyWith({
    MatchDaysStatus status,
    List<MatchDay> matchDays,
    String error,
  }) {
    return MatchDaysState(
      status: status ?? this.status,
      matchDays: matchDays ?? this.matchDays,
      error: error ?? this.error,
    );
  }

  final MatchDaysStatus status;
  final List<MatchDay> matchDays;
  final String error;

  @override
  List<Object> get props => [matchDays, error, status];
}

enum MatchDaysStatus { uninitialized, fetching, complete, error }
