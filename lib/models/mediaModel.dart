class Media {
  bool? isVideo;
  String? url;

  Media({this.isVideo, this.url});

  Media.fromJson(Map<String, dynamic> json) {
    isVideo = json['is_video'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_video'] = this.isVideo;
    data['url'] = this.url;
    return data;
  }
}
