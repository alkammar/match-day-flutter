import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:match_day/bloc/edit_match_day/bloc.dart';
import 'package:match_day/bloc/invite_players/bloc.dart';
import 'package:match_day/model/match_day.dart';
import 'package:match_day/repo/invitation_repository.dart';
import 'package:match_day/repo/matchday_repository.dart';
import 'package:match_day/ui/main_button.dart';
import 'package:match_day/ui/md_text_field.dart';

class CreateMatchDayScreen extends StatefulWidget {
  // final MatchDay matchDay;

  @override
  _CreateMatchDayScreenState createState() => _CreateMatchDayScreenState();

  // CreateMatchDayScreen({this.matchDay});

  static Route route({@required MatchDay matchDay}) {
    print('edit match day $matchDay');
    return MaterialPageRoute(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<InvitePlayersBloc>(
              create: (context) => InvitePlayersBloc(
                    invitationRepository:
                        RepositoryProvider.of<InvitationRepository>(context),
                  )),
          BlocProvider<EditMatchDayBloc>(
              create: (context) => EditMatchDayBloc(
                    matchDay: matchDay,
                    matchDayRepository:
                        RepositoryProvider.of<MatchDayRepository>(context),
                  )),
        ],
        child: CreateMatchDayScreen(),
      );
    });
  }
}

class _CreateMatchDayScreenState extends State<CreateMatchDayScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    BlocProvider.of<EditMatchDayBloc>(context).add(LoadMatchDay());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
          builder: (BuildContext context, state) {
            return Text(state.original?.id == null
                ? 'Create Match Day'
                : 'Edit Match Day');
          },
        ),
      ),
      body: SafeArea(
        child: BlocListener<EditMatchDayBloc, EditMatchDayState>(
          listener: (context, state) {
            if (state.status == EditStatus.complete) Navigator.pop(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
                      buildWhen: (previous, current) =>
                          previous.status == EditStatus.uninitialized,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MdTextField(
                            label: AppLocalizations.of(context).matchDayName,
                            text: '${state.original?.name ?? ''}',
                            onChanged: (text) {
                              BlocProvider.of<EditMatchDayBloc>(context)
                                  .add(EditName(text));
                            },
                          ),
                        );
                      }),
                  BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
                      builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${state.original?.owner?.name}'),
                    );
                  }),
                  BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
                      buildWhen: (previous, current) =>
                          previous.status == EditStatus.uninitialized,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MdTextField(
                            label: 'Match Day Location',
                            text: '${state.original?.location}',
                            onChanged: (text) {
                              BlocProvider.of<EditMatchDayBloc>(context)
                                  .add(EditLocation(text));
                            },
                          ),
                        );
                      }),
                  BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
                    builder: (BuildContext context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: MainButton(
                          loading: false,
                          onPressed: () =>
                              BlocProvider.of<InvitePlayersBloc>(context)
                                  .add(SendInvitation(state.original)),
                          label: 'Add Player',
                        ),
                      );
                    },
                  ),
                ],
              ),
              BlocBuilder<EditMatchDayBloc, EditMatchDayState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: MainButton(
                        onPressed: state.status == EditStatus.edited
                            ? () => BlocProvider.of<EditMatchDayBloc>(context)
                                .add(SubmitEdits())
                            : null,
                        loading: state.status == EditStatus.submitting,
                        label: state.original?.id == null ? 'Create' : 'Submit',
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
