import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/invitation_repository.dart';
import 'package:share/share.dart';

part 'event.dart';

part 'state.dart';

class InvitePlayersBloc extends Bloc<InvitePlayersEvent, InvitePlayersState> {
  final InvitationRepository _invitationRepository;

  InvitePlayersBloc({
    @required InvitationRepository invitationRepository,
  })  : _invitationRepository = invitationRepository,
        super(const InvitePlayersState());

  @override
  Stream<InvitePlayersState> mapEventToState(InvitePlayersEvent event) async* {
    if (event is FetchContacts) {
      yield* _loadContacts(event);
    } else if (event is SendInvitation) {
      yield* _sendInvitation(event);
    }
  }

  Stream<InvitePlayersState> _loadContacts(FetchContacts event) async* {}

  Stream<InvitePlayersState> _sendInvitation(SendInvitation event) async* {
    var invitationId =
        await _invitationRepository.createInvitation(event.matchDay);

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://morkim.page.link',
      link: Uri.parse(
          'https://morkim.page.link/invite?mdid=${event.matchDay.id}&iid=$invitationId'),
      androidParameters: AndroidParameters(
        packageName: 'com.morkim.koora',
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),
    );

    final shortLink = await parameters.buildShortLink();

    var url = shortLink.shortUrl.toString();
    Share.share(url);
  }
}
