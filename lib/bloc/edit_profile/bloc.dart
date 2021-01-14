import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/profile.dart';
import 'package:match_day/repo/profile_repository.dart';

part 'event.dart';
part 'state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileRepository _profileRepository;

  EditProfileBloc({
    @required ProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(const EditProfileState()) {
    add(Init());
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is Init) {
      yield* _initializeProfile(event);
    } else if (event is EditName) {
      yield* _editName(event);
    } else if (event is SubmitEdits) {
      yield* _updateProfile();
    }
  }

  Stream<EditProfileState> _initializeProfile(Init event) async* {
    Profile profile = await _profileRepository.fetchProfile();
    yield state.copyWith(original: profile, copy: profile.copyWith());
  }

  Stream<EditProfileState> _editName(EditName event) async* {
    state.copyWith(copy: state.copy.copyWith(name: event.name));
    if (state.original != state.copy) {
      yield EditProfileState(status: EditStatus.edited);
    } else {
      yield EditProfileState(status: EditStatus.unedited);
    }
  }

  Stream<EditProfileState> _updateProfile() async* {
    yield EditProfileState(status: EditStatus.submitting);
    yield EditProfileState(original: await _profileRepository.update(state.copy));
    yield EditProfileState(status: EditStatus.complete);
  }
}
