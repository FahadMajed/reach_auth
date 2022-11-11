import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';

class SignIn extends UseCase<User?, SignInRequest> {
  final AuthRepository repository;
  SignIn(this.repository);
  @override
  Future<User?> call(request) async {
    switch (request.authMethod) {
      case AuthMethod.apple:
        return await repository.signWithApple();
      case AuthMethod.google:
        return await repository.signUpWithGoogle();
      case AuthMethod.email:
        return await repository.signInWithEmailAndPassword(
          request.email!,
          request.password!,
        );

      default:
        throw InvalidAuthMethod();
    }
  }
}

class SignInRequest {
  final AuthMethod authMethod;
  final String? email;
  final String? password;

  SignInRequest({
    required this.authMethod,
    this.email,
    this.password,
  });
}

final signInPvdr = Provider<SignIn>((ref) => SignIn(
      ref.read(authRepoPvdr),
    ));
