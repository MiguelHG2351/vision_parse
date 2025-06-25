part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final RequestProgressStatus emailLoginProgressStatus;
  final String emailErrorMessage;
  final Profile profile;

  const AuthState({
    this.emailLoginProgressStatus = RequestProgressStatus.nothing,
    this.emailErrorMessage = '',
    this.profile = const Profile.empty(),
  });

  AuthState copyWith({
    RequestProgressStatus? emailLoginProgressStatus,
    String? emailErrorMessage,
    Profile? profile,
  }) {
    return AuthState(
      emailLoginProgressStatus: emailLoginProgressStatus ?? this.emailLoginProgressStatus,
      emailErrorMessage: emailErrorMessage ?? this.emailErrorMessage,
      profile: profile ?? this.profile,
    );
  }
  
  @override
  List<Object?> get props => [emailLoginProgressStatus];
}
