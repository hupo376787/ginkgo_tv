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
  int videoIndex;
  String channel;
  String logo;
  String pid;
  String sid;
  String programId;
  bool needToken;
  bool mustToken;
  String title;
  List<String> videoUrl;

  Channel({
    required this.id,
    required this.videoIndex,
    required this.channel,
    required this.logo,
    required this.pid,
    required this.sid,
    required this.programId,
    required this.needToken,
    required this.mustToken,
    required this.title,
    required this.videoUrl,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        videoIndex: json["videoIndex"],
        channel: json["channel"],
        logo: json["logo"],
        pid: json["pid"],
        sid: json["sid"],
        programId: json["programId"],
        needToken: json["needToken"],
        mustToken: json["mustToken"],
        title: json["title"],
        videoUrl: List<String>.from(json["videoUrl"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "videoIndex": videoIndex,
        "channel": channel,
        "logo": logo,
        "pid": pid,
        "sid": sid,
        "programId": programId,
        "needToken": needToken,
        "mustToken": mustToken,
        "title": title,
        "videoUrl": List<dynamic>.from(videoUrl.map((x) => x)),
      };
}
