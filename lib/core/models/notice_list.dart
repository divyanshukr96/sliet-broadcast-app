class NoticesList {
  int count;
  int next;
  Null previous;
  List<Notice> results;

  DateTime lastFetch;

  NoticesList({this.count, this.next, this.previous, this.results});

  NoticesList.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Notice>();
      json['results'].forEach((v) {
        results.add(new Notice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<Notice> get notices => results;
}

class Notice {
  String id;
  String title;
  String description;
  bool isEvent;
  String date;
  String time;
  String venue;
  String user;
  String userId;
  String username;
  String profile;
  List<String> images;
  List<ImagesList> imagesList;
  bool allDepartment;
  List<String> department;
  bool publicNotice;
  bool visible;
  bool canEdit;
  bool bookmark;
  bool interested;
  String createdAt;
  String datetime;
  String updatedAt;

  Notice(
      {this.id,
      this.title,
      this.description,
      this.isEvent,
      this.date,
      this.time,
      this.venue,
      this.user,
      this.userId,
      this.username,
      this.profile,
      this.images,
      this.imagesList,
      this.allDepartment,
      this.department,
      this.publicNotice,
      this.visible,
      this.canEdit,
      this.bookmark,
      this.interested,
      this.createdAt,
      this.datetime,
      this.updatedAt});

  Notice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isEvent = json['is_event'];
    date = json['date'];
    time = json['time'];
    venue = json['venue'];
    user = json['user'];
    userId = json['user_id'];
    username = json['username'];
    profile = json['profile'];
    if (json['images'] != null) {
      images = json['images'].cast<String>();
    }
    if (json['images_list'] != null) {
      imagesList = new List<ImagesList>();
      json['images_list'].forEach((v) {
        imagesList.add(new ImagesList.fromJson(v));
      });
    }
    allDepartment = json['all_department'];
    department = json['department'].cast<String>();
    publicNotice = json['public_notice'];
    visible = json['visible'];
    canEdit = json['can_edit'];
    bookmark = json['bookmark'];
    interested = json['interested'];
    createdAt = json['created_at'];
    datetime = json['datetime'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['is_event'] = this.isEvent;
    data['date'] = this.date;
    data['time'] = this.time;
    data['venue'] = this.venue;
    data['user'] = this.user;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['profile'] = this.profile;
    data['images'] = this.images;
    if (this.imagesList != null) {
      data['images_list'] = this.imagesList.map((v) => v.toJson()).toList();
    }
    data['all_department'] = this.allDepartment;
    data['department'] = this.department;
    data['public_notice'] = this.publicNotice;
    data['visible'] = this.visible;
    data['can_edit'] = this.canEdit;
    data['bookmark'] = this.bookmark;
    data['interested'] = this.interested;
    data['created_at'] = this.createdAt;
    data['datetime'] = this.datetime;
    data['updated_at'] = this.updatedAt;
    return data;
  }

//  Notice copyWith({
//    String title,
//    String description,
//    bool isEvent,
//    dynamic date,
//    dynamic time,
//    dynamic venue,
//    List<String> images,
//    List<ImagesList> imagesList,
//    bool allDepartment,
//    List<String> department,
//    bool publicNotice,
//    bool visible,
//    bool canEdit,
//    bool bookmark,
//    bool interested,
//  }) =>
//      Notice(
//        id: this.id,
//        title: title ?? this.title,
//        description: description ?? this.description,
//        isEvent: isEvent ?? this.isEvent,
//        date: date ?? this.date,
//        time: time ?? this.time,
//        venue: venue ?? this.venue,
//        user: this.user,
//        userId: this.userId,
//        username: this.username,
//        profile: this.profile,
//        images: images ?? this.images,
//        imagesList: imagesList ?? this.imagesList,
//        allDepartment: allDepartment ?? this.allDepartment,
//        department: department ?? this.department,
//        publicNotice: publicNotice ?? this.publicNotice,
//        visible: visible ?? this.visible,
//        canEdit: canEdit ?? this.canEdit,
//        bookmark: bookmark ?? this.bookmark,
//        interested: interested ?? this.interested,
//        createdAt: this.createdAt,
//        datetime: this.datetime,
//      );
}

class ImagesList {
  String id;
  String url;

  ImagesList({this.id, this.url});

  ImagesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}
