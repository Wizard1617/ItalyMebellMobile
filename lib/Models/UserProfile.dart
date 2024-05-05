class UserProfile {
  final String emailUser;
  final String passwordUser;
  final String roleUser;
  final String? firstNameUser;
  final String? secondNameUser;
  final String? phoneNumberClient;
  final String? imageUserProfile;
  final String createdAt;
  final String updatedAt;

  UserProfile({
    required this.emailUser,
    required this.passwordUser,
    required this.roleUser,
    this.firstNameUser,
    this.secondNameUser,
    this.phoneNumberClient,
    this.imageUserProfile,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      emailUser: json['email_user'],
      passwordUser: json['password_user'],
      roleUser: json['role_user'],
      firstNameUser: json['first_name_user'],
      secondNameUser: json['second_name_user'],
      phoneNumberClient: json['phone_number_client'],
      imageUserProfile: json['image_user_profile'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
