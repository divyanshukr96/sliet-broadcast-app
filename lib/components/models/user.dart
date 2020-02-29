import 'dart:convert';

class User {
  String id;
  String name;
  String email;
  String mobile;
  String username;
  String profileImage;

  String userType;
  bool isAdmin;
  String about;

  String token;

  User({
    this.id,
    this.name,
    this.email,
    this.username,
    this.userType,
    this.isAdmin,
    this.mobile,
    this.about,
    this.profileImage,
    this.token,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        username: json['username'],
        userType: json['user_type'],
        isAdmin: json['is_admin'],
        mobile: json['mobile'],
        about: json['about'],
        profileImage: json['profile'],
        token: json['token'],
      );
}
