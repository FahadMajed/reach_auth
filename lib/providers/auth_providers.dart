import 'package:google_sign_in/google_sign_in.dart';
import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';

final userStreamPvdr = StreamProvider<User?>((ref) => ref.read(authRepoPvdr).userStream);

final userPvdr = StateProvider<AsyncValue<User?>>(
  (ref) {
    final userStream = ref.watch(userStreamPvdr);
    return userStream.when(
      data: (user) => AsyncData(user),
      error: (e, t) => throw e,
      loading: () => const AsyncLoading(),
    );
  },
);

final userIdPvdr = Provider<String>((ref) => ref.watch(userPvdr).value?.uid ?? "");

final authRepoPvdr =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read(authServicePvdr), ref.read(googleSignInPvdr)));

final authServicePvdr = Provider<FirebaseAuth>((ref) => throw UnimplementedError());

final googleSignInPvdr = Provider((ref) => GoogleSignIn());
