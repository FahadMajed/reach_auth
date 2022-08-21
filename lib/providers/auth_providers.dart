import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reach_auth/reach_auth.dart';

final userStreamPvdr =
    StreamProvider((ref) => ref.read(authRepoPvdr).userStream);

final userPvdr = StateNotifierProvider<UserNotifier, AsyncValue<User?>>(
  (ref) {
    final repository = ref.read(authRepoPvdr);
    final userStream = ref.watch(userStreamPvdr);
    return userStream.when(
      data: (user) => UserNotifier(user, repository),
      error: (e, t) => throw e,
      loading: () => UserNotifier(null, repository),
    );
  },
);

final authRepoPvdr = Provider<AuthRepository>((ref) =>
    AuthRepository(ref.read(authServicePvdr), ref.read(googleSignInPvdr)));

final authServicePvdr = Provider((ref) => FirebaseAuth.instance);

final googleSignInPvdr = Provider((ref) => GoogleSignIn());
