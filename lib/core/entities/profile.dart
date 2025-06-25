import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatarUrl;

  const Profile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
  });

  const Profile.empty()
      : id = '',
        email = '',
        firstName = '',
        lastName = '',
        avatarUrl = '';

  Profile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? nationalId,
    String? avatarUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatarUrl: json['avatar'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatarUrl];
}
