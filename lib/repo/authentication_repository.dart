import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:match_day/model/user.dart' as mdUser;

class AuthenticationRepository {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final Stream<mdUser.User> _firebaseAuthStream =
      FirebaseAuth.instance.authStateChanges().map((user) {
    if (user == null) {
      return null;
    } else {
      return mdUser.User(
        id: user.uid,
        name: user.displayName,
      );
    }
  });

  Stream<mdUser.User> get stream {
    return _firebaseAuthStream;
  }

  Future<mdUser.User> signIn() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null && !user.isAnonymous && await user.getIdToken() != null) {
      print('signInWithGoogle succeeded: $user');

      return mdUser.User(
        id: user.uid,
        name: user.displayName,
      );
    }

    return Future.error('Signing in Failed!');
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }
}
