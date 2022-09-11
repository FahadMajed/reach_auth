import 'dart:async';

import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_core/core/data/repositories/notifications_repository.dart';

//firebase user
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository repository;
  late final NotificationsRepository? _notificationsRepository;

  UserNotifier(User? user, this.repository,
      {NotificationsRepository? pushNotificationsSource})
      : super(const AsyncLoading()) {
    state = AsyncData(user);
    _notificationsRepository = pushNotificationsSource;
  }

  Future<void> setDeviceToken() async =>
      _notificationsRepository!.setDeviceToken();

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
      userLoading();
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
      throw e;
    } finally {
      userLoaded();
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
    userLoading();
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
      throw e;
    } finally {
      userLoading();
    }
  }

  Future<User?> _createWithEmail(
      String email, String password, String displayName) async {
    userLoading();
    return await repository
        .createUserWithEmailAndPassword(email, password, displayName)
        .then((user) => user);
    userLoaded();
  }

  Future<User?> _createWithGoogle() async =>
      await repository.signInWithGoogle().then((user) => user);

  Future<User?> _createWithApple() async =>
      await repository.signInWithApple().then((user) => user);

  Future<void> convert(AuthMethod method) async {
    try {
      userLoading();
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
      throw e;
    } finally {
      userLoaded();
    }
  }
}

//providers
final RxBool isUserLoading = false.obs;

void userLoading() => isUserLoading.value = true;
Future<void> userLoaded() async => isUserLoading.value = false;
