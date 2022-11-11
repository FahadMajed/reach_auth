import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';

class ConvertUser extends UseCase<ConverUserResponse, ConvertUserRequest> {
  final AuthRepository repository;
  final ParticipantsRepository participantsRepository;
  ConvertUser(this.repository, this.participantsRepository);
  late final ConvertUserRequest _request;
  late final User? _user;
  Participant? _updatedParticipant;
  Participant get _participant => _request.participant;
  @override
  Future<ConverUserResponse> call(request) async {
    _request = request;

    switch (request.authMethod) {
      case AuthMethod.apple:
        _user = await repository.convertWithApple();
        break;
      case AuthMethod.google:
        _user = await repository.convertWithGoogle();
        break;
      default:
        throw InvalidAuthMethod();
    }

    _updateParticipantName();

    return ConverUserResponse(
      converted: _user?.isAnonymous ?? false,
      participant: _updatedParticipant ?? _participant,
      userDisplayName: _user?.displayName ?? "",
    );
  }

  Future<void> _updateParticipantName() async {
    if (_user != null && _user!.displayName!.isNotEmpty) {
      if (_participant.nameIsNotSet) {
        _updatedParticipant = _participant.copyWith(name: _user?.displayName);
        participantsRepository.updateParticipant(_updatedParticipant!);
      }
    }
  }
}

class ConvertUserRequest {
  final Participant participant;
  final AuthMethod authMethod;

  ConvertUserRequest({
    required this.participant,
    required this.authMethod,
  });
}

class ConverUserResponse {
  final bool converted;
  final Participant participant;
  final String userDisplayName;
  ConverUserResponse({
    required this.userDisplayName,
    required this.converted,
    required this.participant,
  });
}

final convertUserPvdr = Provider<ConvertUser>(
  (ref) => ConvertUser(
    ref.read(authRepoPvdr),
    ref.read(partsRepoPvdr),
  ),
);
