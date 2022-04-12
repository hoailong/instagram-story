class Story {
  String? id;
  String? profilePicUrl;
  String? username;
  int? seen;

  Story({this.id, this.profilePicUrl, this.username, this.seen});

  Story.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profilePicUrl = json['profile_pic_url'];
    username = json['username'];
    seen = json['seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_pic_url'] = this.profilePicUrl;
    data['username'] = this.username;
    data['seen'] = this.seen;
    return data;
  }
}
