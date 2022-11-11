// ignore_for_file: avoid_renaming_method_parameters

import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';

class ForgetPassword extends UseCase<void, String> {
  final AuthRepository repository;
  ForgetPassword(this.repository);
  @override
  Future<void> call(email) async => await repository.sendPasswordResetEmail(email);
}

final forgetPasswordPvdr = Provider<ForgetPassword>((ref) => ForgetPassword(
      ref.read(authRepoPvdr),
    ));
