part of 'bloc.dart';

class EditProfileState extends Equatable {
  const EditProfileState({
    this.original,
    this.copy,
    this.status = EditStatus.uninitialized,
    this.error = '',
  });

  EditProfileState copyWith({
    Profile original,
    Profile copy,
    EditStatus status,
    String error,
  }) {
    return EditProfileState(
      original: original ?? this.original,
      copy: copy ?? this.copy,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  final Profile original;
  final Profile copy;
  final EditStatus status;
  final String error;

  @override
  List<Object> get props => [original, copy, status];
}

enum EditStatus { uninitialized, unedited, edited, submitting, complete, error }
