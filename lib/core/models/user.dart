class User {
  String id;
  String name;
  String email;
  String mobile;
  String username;
  String userType;
  bool isAdmin;
  bool newUser;
  String about;
  ExtraFields extraFields;
  String profile;
  Details details;
  String token;

  User({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.username,
    this.userType,
    this.isAdmin,
    this.newUser,
    this.about,
    this.extraFields,
    this.profile,
    this.details,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        username: json["username"],
        userType: json["user_type"],
        isAdmin: json["is_admin"],
        newUser: json["new_user"] ?? false,
        about: json["about"],
        extraFields: json["extra_fields"] != null
            ? ExtraFields.fromJson(json["extra_fields"])
            : null,
        profile: json["profile"],
        details:
            json["details"] != null ? Details.fromJson(json["details"]) : null,
        token: json["token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "username": username,
        "user_type": userType,
        "is_admin": isAdmin,
        "new_user": newUser ?? false,
        "about": about,
        "extra_fields": extraFields != null ? extraFields.toJson() : null,
        "profile": profile,
        "details": details != null ? details.toJson() : null,
        "token": token ?? null,
      };
}

class Details {
  UserClass user;
  String department;
  String registrationNumber;
  int batch;
  String program;
  String gender;
  dynamic dob;

  String facultyAdviser;

  String convener;

  String designation;

  Details({
    this.user,
    this.department,
    this.registrationNumber,
    this.batch,
    this.program,
    this.gender,
    this.dob,
    this.facultyAdviser,
    this.convener,
    this.designation,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        user: UserClass.fromJson(json["user"]),
        department: json["department"],
        registrationNumber: json["registration_number"],
        batch: json["batch"],
        program: json["program"],
        gender: json["gender"],
        dob: json["dob"] ?? '',
        facultyAdviser: json["faculty_adviser"] ?? '',
        convener: json["convener"] ?? '',
        designation: json["designation"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "department": department,
        "registration_number": registrationNumber,
        "batch": batch,
        "program": program,
        "gender": gender,
        "dob": dob,
        "faculty_adviser": facultyAdviser,
        "convener": convener,
        "designation": designation,
      };
}

class UserClass {
  String id;
  String name;
  String email;
  String mobile;
  String username;

  UserClass({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.username,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "username": username,
      };
}

class ExtraFields {
  ExtraFields();

  factory ExtraFields.fromJson(Map<String, dynamic> json) => ExtraFields();

  Map<String, dynamic> toJson() => {};
}

enum UserType { DEPARTMENT, SOCIETY, FACULTY, STUDENT, CHANNEL }
