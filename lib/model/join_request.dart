import 'package:equatable/equatable.dart';
import 'package:match_day/model/invitation.dart';
import 'package:match_day/model/profile.dart';

class JoinRequest extends Equatable {
  final String id;
  final Profile profile;
  final Invitation invitation;

  JoinRequest({this.id, this.profile, this.invitation});

  @override
  List<Object> get props => [id, profile, invitation];
}
