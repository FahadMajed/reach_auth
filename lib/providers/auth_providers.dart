import 'package:google_sign_in/google_sign_in.dart';
import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_core/core/data/repositories/notifications_repository.dart';

final userStreamPvdr =
    StreamProvider((ref) => ref.read(authRepoPvdr).userStream);

final userPvdr = StateNotifierProvider<UserNotifier, AsyncValue<User?>>(
  (ref) {
    final repository = ref.read(authRepoPvdr);
    final notificationsRepository = ref.watch(notificationsRepoPvdr);
    final userStream = ref.watch(userStreamPvdr);
    return userStream.when(
      data: (user) => UserNotifier(
        user,
        repository,
        pushNotificationsSource: notificationsRepository,
      )..setDeviceToken(),
      error: (e, t) => throw e,
      loading: () => UserNotifier(
        null,
        repository,
        pushNotificationsSource: notificationsRepository,
      ),
    );
  },
);

final userIdPvdr =
    Provider<String>((ref) => ref.watch(userPvdr).value?.uid ?? "");

final authRepoPvdr = Provider<AuthRepository>((ref) =>
    AuthRepository(ref.read(authServicePvdr), ref.read(googleSignInPvdr)));

final authServicePvdr = Provider((ref) => FirebaseAuth.instance);

final googleSignInPvdr = Provider((ref) => GoogleSignIn());
