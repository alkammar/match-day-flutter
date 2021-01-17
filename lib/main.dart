import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:match_day/bloc/authentication/bloc.dart';
import 'package:match_day/bloc/dynamic_link/bloc.dart';
import 'package:match_day/repo/authentication_repository.dart';
import 'package:match_day/repo/invitation_repository.dart';
import 'package:match_day/repo/matchday_repository.dart';
import 'package:match_day/repo/profile_repository.dart';
import 'package:match_day/ui/create_match_day_screen.dart';
import 'package:match_day/ui/edit_profile_screen.dart';
import 'package:match_day/ui/home_screen.dart';
import 'package:match_day/ui/invitation_screen.dart';
import 'package:match_day/ui/login_screen.dart';
import 'package:match_day/ui/splash_screen.dart';

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
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return MatchDayView();
        } else {
          return MaterialApp(home: SplashScreen());
        }
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => AuthenticationRepository()),
        RepositoryProvider<ProfileRepository>(
            create: (context) => ProfileRepository()),
        RepositoryProvider<MatchDayRepository>(
            create: (context) => MatchDayRepository()),
        RepositoryProvider<InvitationRepository>(
            create: (context) => InvitationRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(create: (context) {
            return AuthenticationBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            );
            // );
          }),
          BlocProvider<DynamicLinkBloc>(create: (context) {
            return DynamicLinkBloc();
          }),
        ],
        child: MaterialApp(
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
          home: SplashScreen(),
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
                BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    if (state.status == AuthenticationStatus.signedOut) {
                      _navigator.pushNamed('/login');
                    } else if (state.status == AuthenticationStatus.signedIn) {
                      _navigator.pushNamedAndRemoveUntil(
                          '/home', (route) => false);
                    }
                  },
                ),
              ],
              child: child,
            );
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/login') {
              return LoginScreen.route();
            } else if (settings.name == '/home') {
              return HomeScreen.route();
            } else if (settings.name == '/create') {
              return CreateMatchDayScreen.route(matchDay: settings.arguments);
            } else if (settings.name == '/details') {
              return CreateMatchDayScreen.route(matchDay: settings.arguments);
            } else if (settings.name == '/invite') {
              return InvitationScreen.route(uri: settings.arguments);
            } else if (settings.name == '/edit-profile') {
              return EditProfileScreen.route();
            } else {
              return MaterialPageRoute(builder: (context) => null);
            }
          },
        ),
      ),
    );
  }
}
