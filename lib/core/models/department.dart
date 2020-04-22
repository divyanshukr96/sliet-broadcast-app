class Department {
  String id;
  String username;
  String name;

  Department({
    this.id,
    this.username,
    this.name,
  });

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    return data;
  }
}
