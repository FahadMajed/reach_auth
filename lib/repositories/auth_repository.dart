import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  AuthRepository(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;

  final GoogleSignIn _googleSignIn;

  User? get getUser => _auth.currentUser;

  Stream<User?> get userStream => _auth.userChanges();

  String? getCurrentUID() => _auth.currentUser?.uid;

  User? getCurrentUser() => _auth.currentUser;

  void updateUserName(String? name) => _auth.currentUser?.updateDisplayName(name);

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final credentials = (await _auth.signInWithEmailAndPassword(email: email, password: password));

    return credentials.user;
  }

  Future<void> signOut() async => await _auth.signOut();

  Future<bool> get appleSignInAvailable => SignInWithApple.isAvailable();

  Future<User?> convertWithApple() async {
    try {
      final appleResult = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // final name = '${appleResult.givenName} ${appleResult.familyName}';

      final AuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken: appleResult.authorizationCode,
        idToken: appleResult.identityToken,
      );

      final currentUser = _auth.currentUser;
      currentUser?.linkWithCredential(credential);

      return currentUser;
    } catch (error) {
      log(error.toString());
      return getUser;
    }
  }

  Future<User?> signWithApple() async {
    return await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    ).then((result) async {
      switch (result.state) {
        case "authorized":
          final OAuthProvider oAuthProvider = OAuthProvider("apple.com");

          final AuthCredential credential = oAuthProvider.credential(
            idToken: result.identityToken,
            accessToken: result.authorizationCode,
          );

          // update the user information

          final userCredential = await _auth.signInWithCredential(credential);

          return userCredential.user;

        default:
          return null;
          return throw Exception("${result.authorizationCode}:  ${result.state}");
      }
    });
  }

  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<User?> singUpAnonymously() async {
    final credential = await _auth.signInAnonymously();
    return credential.user;
  }

  Future convertUserWithEmail(String email, String password) async {
    final currentUser = _auth.currentUser;

    final credential = EmailAuthProvider.credential(email: email, password: password);
    await currentUser?.linkWithCredential(credential);
  }

  Future<User?> convertWithGoogle() async {
    final currentUser = _auth.currentUser;
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account != null) {
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await currentUser?.linkWithCredential(credential);

      updateUserName(_googleSignIn.currentUser?.displayName);
      return currentUser;
    }
    return null;
  }

  // GOOGLE
  Future<User?> signUpWithGoogle() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account != null) {
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      return (await _auth.signInWithCredential(credential)).user;
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(email, password, name) async {
    return _auth.createUserWithEmailAndPassword(email: email, password: password).then(
      (userCredential) {
        _auth.currentUser?.updateDisplayName(name);
        return userCredential.user;
      },
    );
  }
}
