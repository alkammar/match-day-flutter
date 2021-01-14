import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/bloc/fetch_match_days/bloc.dart';
import 'package:match_day/bloc/pending_invitation/bloc.dart';
import 'package:match_day/ui/main_button.dart';

class InvitationScreen extends StatefulWidget {
  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invitation!"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() => BlocProvider.of<FetchMatchDaysBloc>(context)
              .add(MatchDaysRequested()));
        },
        child: BlocBuilder<PendingInvitationBloc, PendingInvitationState>(
          builder: (context, state) {
            debugPrint('state ${state.toString()}');
            if (state.error.isNotEmpty) {
              return Center(child: Text(state.error));
            } else if (state.status == PendingInvitationStatus.accepting ||
                state.status == PendingInvitationStatus.declining) {
              return Center(child: CircularProgressIndicator());
            } else if (state.status == PendingInvitationStatus.error) {
              return Center(child: Text("Invitation Expired for instance!"));
            } else {
              return Center(
                child: Column(
                  children: [
                    Text(
                        'You have been invited to ${state.invitation?.matchDay?.name ?? 'unknown'}'),
                    MainButton(
                      label: 'Join',
                      onPressed: () {
                        BlocProvider.of<PendingInvitationBloc>(context)
                            .add(AskToJoinMatchDay());
                      },
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
