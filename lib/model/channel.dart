// To parse this JSON data, do
//
//     final channel = channelFromJson(jsonString);

import 'dart:convert';

List<Channel> channelFromJson(String str) =>
    List<Channel>.from(json.decode(str).map((x) => Channel.fromJson(x)));

String channelToJson(List<Channel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Channel {
  int id;
  String tvName;
  String tvLogo;
  String group;
  String title;
  List<String> videoUrl;

  Channel({
    required this.id,
    required this.tvName,
    required this.tvLogo,
    required this.group,
    required this.title,
    required this.videoUrl,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        tvName: json["tvName"],
        tvLogo: json["tvLogo"],
        title: json["title"],
        group: json["group"],
        videoUrl: List<String>.from(json["videoUrl"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tvName": tvName,
        "tvLogo": tvLogo,
        "title": title,
        "group": group,
        "videoUrl": List<dynamic>.from(videoUrl.map((x) => x)),
      };
}
