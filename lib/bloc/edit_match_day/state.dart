part of 'bloc.dart';

class EditMatchDayState extends Equatable {
  const EditMatchDayState._({
    this.original,
    this.copy,
    this.status = EditStatus.uninitialized,
    this.error = '',
  });

  const EditMatchDayState.unknown() : this._();

  const EditMatchDayState.initialized(MatchDay original) : this._(original: original, status: EditStatus.unedited);

  const EditMatchDayState.edited(MatchDay matchDay, MatchDay copy) : this._(original: matchDay, copy: copy, status: EditStatus.edited);

  const EditMatchDayState.unedited(MatchDay matchDay) : this._(original: matchDay, copy: matchDay, status: EditStatus.unedited);

  const EditMatchDayState.submitting() : this._(status: EditStatus.submitting);

  const EditMatchDayState.submitted() : this._(status: EditStatus.complete);

  final MatchDay original;
  final MatchDay copy;
  final EditStatus status;
  final String error;

  @override
  List<Object> get props => [original, copy, status];
}

enum EditStatus {
  uninitialized, unedited, edited, submitting, complete, error
}