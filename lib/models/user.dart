class UserModel {
  final String uid;
  final String username;
  final String platform;
  final String token;
  final String createdAt;

  const UserModel({
    required this.createdAt,
    required this.username,
    required this.platform,
    required this.token,
    required this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        createdAt: json['createdAt'],
        platform: json['platform'],
        token: json['token'],
        username: json['username'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'token': token,
        'platform': platform,
        'createdAt': createdAt,
        'username': username,
      };
}