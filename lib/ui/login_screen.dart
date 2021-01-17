import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_day/bloc/authentication/bloc.dart';
import 'package:match_day/ui/main_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();

  static Route route() {
    return MaterialPageRoute(builder: (context) {
      return LoginScreen();
    });
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Login!"),
        ),
        body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            // if (state.status == AuthenticationStatus.signedIn) {
            //   Navigator.pop(context);
            // }
          },
          builder: (context, state) {
            debugPrint('state ${state.toString()}');
            return Center(
              child: MainButton(
                label: 'Login',
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LogIn());
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
