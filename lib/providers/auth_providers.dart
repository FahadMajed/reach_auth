import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_auth/reach_auth.dart';

final userPvdr = StateNotifierProvider<UserNotifier, AsyncValue<User?>>(
  (ref) => UserNotifier(ref.read)
    ..appStarted()
    ..addToken(collection: "researchers"),
);
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authRepoPvdr = Provider<AuthRepository>(
    (ref) => AuthRepository(ref.watch(firebaseAuthProvider)));

final isAnonPvdr = StateProvider((ref) => false);
final emailPvdr = StateProvider<String>((ref) => "");
