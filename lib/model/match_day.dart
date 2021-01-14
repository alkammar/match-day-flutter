import 'package:equatable/equatable.dart';
import 'package:match_day/model/admin.dart';

class MatchDay extends Equatable {
  final String id;
  final String name;
  final User admin;
  final String location;
  final bool invitation;

  MatchDay({
    this.id,
    this.name,
    this.admin,
    this.location,
    this.invitation = false,
  });

  @override
  List<Object> get props => [id, name, admin, location, invitation];

  MatchDay copyWith({
    String id,
    String name,
    User admin,
    String location,
    bool invitation,
  }) {
    MatchDay matchDay = MatchDay(
      id: id ?? this.id,
      name: name ?? this.name,
      admin: admin ?? this.admin,
      location: location ?? this.location,
      invitation: invitation ?? this.invitation,
    );

    return matchDay;
  }
}
