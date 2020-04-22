class Register {
  String name;
  String email;
  String mobile;
  String username;
  String password;
  String department;
  String designation;
  String registrationNumber;
  String program;
  String gender;
  String batch;
  String dob;

  Register({
    this.name,
    this.email,
    this.mobile,
    this.username,
    this.password,
    this.department,
    this.designation,
    this.registrationNumber,
    this.program,
    this.gender,
    this.batch,
    this.dob,
  });

  factory Register.fromJson(Map<String, dynamic> json) =>
      Register(
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        username: json["username"],
        password: json["password"],
        department: json["department"],
        designation: json["designation"],
        registrationNumber: json["registration_number"],
        program: json["program"],
        gender: json["gender"],
        batch: json["batch"],
        dob: json["dob"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mobile": mobile,
        "username": username,
        "password": password,
        "department": department,
        "designation": designation,
        "registration_number": registrationNumber,
        "program": program,
        "gender": gender,
        "batch": batch,
        "dob": dob,
      };
}
