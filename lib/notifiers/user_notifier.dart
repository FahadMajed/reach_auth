import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_auth/reach_auth.dart';

//firebase user
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final Reader _read;
  late AuthRepository repository;
  late StreamSubscription<User?>? _authStateChangesSubscription;

  UserNotifier(this._read) : super(const AsyncLoading()) {
    repository = _read(authRepoPvdr);

    _authStateChangesSubscription = repository.userStream.listen((user) {
      state = AsyncData(user);
      _read(isAnonPvdr.notifier).state = user?.isAnonymous ?? false;
      _read(emailPvdr.notifier).state = user?.email ?? "";
    });
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  void appStarted() => repository.getCurrentUser();
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

  Future signIn(AuthMethod method, {String? email, String? password}) async {
    try {
      state = const AsyncLoading();
      switch (method) {
        case AuthMethod.email:
          state = AsyncData(await signWithEmail(email!, password!));
          break;

        case AuthMethod.google:
          state = AsyncData(await signWithGoogle());
          break;

        case AuthMethod.apple:
          state = AsyncData(await signWithApple());
          break;
        default:
      }
    } catch (e) {
      state = AsyncError(e);
    }
  }

  Future signWithEmail(String email, String password) async =>
      await repository.signInWithEmailAndPassword(email, password);

  Future signWithGoogle() async => await repository.signInWithGoogle();

  Future signWithApple() async => await repository.signInWithApple();

  Future sendPasswordResetEmail(String email) async =>
      await repository.sendPasswordResetEmail(email);

  Future<void> createAccount(AuthMethod method,
      {String? email, String? password, String? displayName}) async {
    state = const AsyncLoading();
    try {
      switch (method) {
        case AuthMethod.email:
          state =
              AsyncData(await createWithEmail(email!, password!, displayName!));
          break;

        case AuthMethod.google:
          state = AsyncData(await createWithGoogle());
          break;

        case AuthMethod.apple:
          state = AsyncData(await createWithApple());
          break;
      }
    } catch (e) {
      state = AsyncError(e);
    }
  }

  Future<User?> createWithEmail(
      String email, String password, String displayName) async {
    return await repository
        .createUserWithEmailAndPassword(email, password, displayName)
        .then((user) => user);
  }

  Future<User?> createWithGoogle() async =>
      await repository.signInWithGoogle().then((user) => user);

  Future<User?> createWithApple() async =>
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
