import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_auth/reach_auth.dart';

//firebase user
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository repository;

  UserNotifier(User? user, this.repository) : super(const AsyncLoading()) {
    state = user == null ? const AsyncLoading() : AsyncData(user);
  }

//TODO FIX
  Future<void> addToken({required String collection}) async {
    // final String? deviceToken = await fcm.getToken();
    // _read(databaseProvider)
    //     .collection(collection)
    //     .doc(repository.getCurrentUID())
    //     .update({"token": deviceToken});
  }

  Future<void> signOut() async {
    state = const AsyncData(null);
    await repository.signOut();
  }

  Future<void> signIn(
    AuthMethod method, {
    String? email,
    String? password,
  }) async {
    try {
      state = const AsyncLoading();
      switch (method) {
        case AuthMethod.email:
          state = AsyncData(await _signWithEmail(email!, password!));
          break;

        case AuthMethod.google:
          state = AsyncData(await _signWithGoogle());
          break;

        case AuthMethod.apple:
          state = AsyncData(await _signWithApple());
          break;
        case AuthMethod.anon:
          state = AsyncData(await repository.singInAnonymously());
          break;

        default:
      }
    } catch (e) {
      state = AsyncError(e);
    }
  }

  Future<User?> _signWithEmail(String email, String password) async =>
      await repository.signInWithEmailAndPassword(email, password);

  Future<User?> _signWithGoogle() async => await repository.signInWithGoogle();

  Future<User?> _signWithApple() async => await repository.signInWithApple();

  Future sendPasswordResetEmail(String email) async =>
      await repository.sendPasswordResetEmail(email);

  Future<void> createAccount(AuthMethod method,
      {String? email, String? password, String? displayName}) async {
    state = const AsyncLoading();
    try {
      switch (method) {
        case AuthMethod.email:
          state = AsyncData(
              await _createWithEmail(email!, password!, displayName!));
          break;

        case AuthMethod.google:
          state = AsyncData(await _createWithGoogle());
          break;

        case AuthMethod.apple:
          state = AsyncData(await _createWithApple());
          break;
        case AuthMethod.anon:
          state = AsyncData(await repository.singInAnonymously());
          break;
      }
    } catch (e) {
      state = AsyncError(e);
    }
  }

  Future<User?> _createWithEmail(
      String email, String password, String displayName) async {
    return await repository
        .createUserWithEmailAndPassword(email, password, displayName)
        .then((user) => user);
  }

  Future<User?> _createWithGoogle() async =>
      await repository.signInWithGoogle().then((user) => user);

  Future<User?> _createWithApple() async =>
      await repository.signInWithApple().then((user) => user);

  Future<void> convert(AuthMethod method) async {
    try {
      state = const AsyncLoading();
      switch (method) {
        case AuthMethod.google:
          state = AsyncData(await repository.convertWithGoogle());
          break;

        case AuthMethod.apple:
          state = AsyncData(await repository.convertWithApple());
          break;
        default:
      }
    } catch (e) {
      state = AsyncError(e);
    }
  }
}

//providers
