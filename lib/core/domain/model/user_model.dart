class UserModel {
  final String? userName;

  UserModel({required this.userName});

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      userName: json?['userName'] as String?,
    );
  }
}