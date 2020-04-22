import 'package:sliet_broadcast/core/models/notice_list.dart';

class Channel {
  String id;
  String name;
  String username;
  String profile;
  String userType;
  bool isAdmin;
  bool following;
  bool auth;
  bool canUnFollow;
  List<Notice> notices;

  Channel({
    this.id,
    this.name,
    this.username,
    this.profile,
    this.userType,
    this.isAdmin,
    this.following,
    this.auth,
    this.canUnFollow,
  });

  Channel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    profile = json['profile'] ?? "";
    userType = json['user_type'];
    isAdmin = json['is_admin'];
    following = json['following'];
    auth = json['auth'];
    canUnFollow = json['can_un_follow'];
    if (json['notices'] != null) {
      notices = new List<Notice>();
      json['notices'].forEach((v) {
        notices.add(new Notice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['profile'] = this.profile ?? null;
    data['user_type'] = this.userType;
    data['is_admin'] = this.isAdmin;
    data['following'] = this.following;
    data['auth'] = this.auth;
    data['can_un_follow'] = this.canUnFollow;
    if (this.notices != null) {
      data['notices'] = this.notices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
