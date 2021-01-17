import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;

  User({this.id, this.name});

  @override
  List<Object> get props => [id, name];

  User copyWith({
    String id,
    String name,
    String nickName,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
