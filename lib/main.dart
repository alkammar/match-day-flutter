import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:match_day/bloc/create_match_day/bloc.dart';
import 'package:match_day/bloc/dynamic_link/bloc.dart';
import 'package:match_day/bloc/edit_match_day/bloc.dart';
import 'package:match_day/bloc/fetch_match_days/bloc.dart';
import 'package:match_day/bloc/invite_players/bloc.dart';
import 'package:match_day/bloc/pending_invitation/bloc.dart';
import 'package:match_day/repo/invitation_repository.dart';
import 'package:match_day/repo/matchday_repository.dart';
import 'package:match_day/ui/create_match_day_screen.dart';
import 'package:match_day/ui/home_screen.dart';
import 'package:match_day/ui/invitation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = true;
  runApp(MatchDayApp());
}

class MatchDayApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<MatchDayRepository>(create: (context) => MatchDayRepository()),
            RepositoryProvider<InvitationRepository>(create: (context) => InvitationRepository()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DynamicLinkBloc>(create: (context) {
                return DynamicLinkBloc();
              }),
            ],
            child: MatchDayView(),
          ),
        );
      },
    );
  }
}

class MatchDayView extends StatefulWidget {
  @override
  _MatchDayViewState createState() => _MatchDayViewState();
}

class _MatchDayViewState extends State<MatchDayView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ar', ''),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: _navigatorKey,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<FetchMatchDaysBloc>(create: (context) {
            return FetchMatchDaysBloc(
              matchDayRepository: RepositoryProvider.of<MatchDayRepository>(context),
              invitationRepository: RepositoryProvider.of<InvitationRepository>(context),
            );
          }),
        ],
        child: HomeScreen(),
      ),
      builder: (context, child) {
        return MultiBlocListener(
          listeners: [
            BlocListener<DynamicLinkBloc, DynamicLinkState>(
              listener: (context, state) {
                print('deeplink ${state.link}');
                _navigator.pushNamed(
                  state.link.path,
                  arguments: state.link,
                );
              },
            ),
          ],
          child: child,
        );
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/create') {
          return MaterialPageRoute(builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<InvitePlayersBloc>(create: (context) => InvitePlayersBloc()),
                BlocProvider<EditMatchDayBloc>(
                    create: (context) => EditMatchDayBloc(
                          matchDay: settings.arguments,
                          matchDayRepository: RepositoryProvider.of<MatchDayRepository>(context),
                        )),
                BlocProvider<CreateMatchDayBloc>(
                    create: (context) => CreateMatchDayBloc(
                          matchDayRepository: RepositoryProvider.of<MatchDayRepository>(context),
                          editMatchDayBloc: BlocProvider.of<EditMatchDayBloc>(context),
                        )),
              ],
              child: CreateMatchDayScreen(),
            );
          });
        } else if (settings.name == '/details') {
          return MaterialPageRoute(builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<InvitePlayersBloc>(create: (context) => InvitePlayersBloc()),
                BlocProvider<EditMatchDayBloc>(
                    create: (context) => EditMatchDayBloc(
                          matchDay: settings.arguments,
                          matchDayRepository: RepositoryProvider.of<MatchDayRepository>(context),
                        )),
              ],
              child: CreateMatchDayScreen(matchDay: settings.arguments),
            );
          });
        } else if (settings.name == '/invite') {
          return MaterialPageRoute(builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<PendingInvitationBloc>(
                    create: (context) => PendingInvitationBloc(
                          uri: settings.arguments,
                          invitationRepository: RepositoryProvider.of<InvitationRepository>(context),
                        )),
              ],
              child: InvitationScreen(),
            );
          });
        } else {
          return MaterialPageRoute(builder: (context) => null);
        }
      },
    );
  }
}
