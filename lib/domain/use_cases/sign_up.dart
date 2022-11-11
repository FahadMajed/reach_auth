import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';

class SignUp extends UseCase<User?, SignUpRequest> {
  final AuthRepository repository;
  SignUp(this.repository);
  @override
  Future<User?> call(request) async {
    switch (request.authMethod) {
      case AuthMethod.anon:
        return repository.singUpAnonymously();

      case AuthMethod.apple:
        return repository.signWithApple();

      case AuthMethod.google:
        return repository.signUpWithGoogle();

      case AuthMethod.email:
        return repository.createUserWithEmailAndPassword(
          request.email!,
          request.password!,
          request.name!,
        );
      default:
        throw InvalidAuthMethod();
    }
  }
}

class SignUpRequest {
  final String? email;
  final String? password;
  final String? name;
  final AuthMethod authMethod;
  SignUpRequest({
    required this.authMethod,
    this.email,
    this.name,
    this.password,
  });
}

final signUpPvdr = Provider<SignUp>((ref) => SignUp(
      ref.read(authRepoPvdr),
    ));
