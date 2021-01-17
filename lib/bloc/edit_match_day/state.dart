part of 'bloc.dart';

class EditMatchDayState extends Equatable {
  const EditMatchDayState({
    this.original,
    this.copy,
    this.status = EditStatus.uninitialized,
    this.error = '',
  });

  final MatchDay original;
  final MatchDay copy;
  final EditStatus status;
  final String error;

  EditMatchDayState copyWith({
    MatchDay original,
    MatchDay copy,
    EditStatus status,
    String error,
  }) {
    return EditMatchDayState(
      original: original ?? this.original,
      copy: copy ?? this.copy,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [original, copy, status];
}

enum EditStatus { uninitialized, unedited, edited, submitting, complete, error }
