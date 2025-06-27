import 'package:equatable/equatable.dart';


enum PaymentStatus {
  active,
  none,
}
class Profile extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String paymentMethod;
  final String paidAt;
  final PaymentStatus paymentStatus;

  const Profile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    this.paymentMethod = '',
    this.paidAt = '',
    this.paymentStatus = PaymentStatus.none,
  });

  const Profile.empty()
      : id = '',
        email = '',
        firstName = '',
        lastName = '',
        avatarUrl = '',
        paymentMethod = '',
        paidAt = '',
        paymentStatus = PaymentStatus.none;

  Profile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? paymentMethod,
    String? paidAt,
    PaymentStatus? paymentStatus,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAt: paidAt ?? this.paidAt,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatarUrl: json['avatar'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paidAt: json['paid_at'] ?? '',
      paymentStatus: json['payment_method'] != null
          ? PaymentStatus.active
          : PaymentStatus.none,
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatarUrl, paymentMethod, paidAt, paymentStatus];
}
