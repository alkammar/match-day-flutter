import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String name;
  final String nickName;

  Profile({this.id, this.name, this.nickName});

  @override
  List<Object> get props => [id, name, nickName];

  Profile copyWith({
    String id,
    String name,
    String nickName,
  }) {
    Profile profile = Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      nickName: nickName ?? this.nickName,
    );

    return profile;
  }
}
