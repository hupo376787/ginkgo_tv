import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ginkgo_tv/helper/toast_helper.dart';
import 'package:ginkgo_tv/main.dart';
import 'package:ginkgo_tv/model/channel.dart';
import 'package:http/http.dart' as http;

class PupupWidget extends StatefulWidget {
  const PupupWidget({super.key});

  @override
  State<PupupWidget> createState() => _PupupWidgetState();
}

List<Channel> chns = <Channel>[];

class _PupupWidgetState extends State<PupupWidget> {
  final MainController mainController = Get.put(MainController());

  Future<void> getData() async {
    if (chns.isNotEmpty) return;
    await downloadAndReadFile(
        'https://gitee.com/hupo376787/LiveList/raw/main/IPTV.m3u');
  }

  Future<void> downloadAndReadFile(String url) async {
    try {
      // 下载文件
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // 将文件内容解码为字符串
        String content = utf8.decode(response.bodyBytes);
        // 输出内容
        debugPrint('文件内容: $content');

        List<String> lines = content.split("\n");
        for (int i = 1; i < lines.length; i = i + 2) {
          if (lines[i].isEmpty) continue;
          debugPrint(lines[i]);

          var chl = Channel(
              id: i,
              tvName: lines[i].split(",")[0].split(" ")[1],
              tvLogo: lines[i].split(",")[0].split(" ")[2],
              group: lines[i].split(",")[0].split(" ")[3],
              title: lines[i].split(",")[1],
              videoUrl: List.from([lines[i + 1]]));

          if (chl.videoUrl.isNotEmpty) {
            chns.add(chl);
          }
        }

        // if (player.platform is NativePlayer) {
        // } else {
        //   await (player.platform as dynamic).setProperty('cache', 'no');
        // }
      } else {
        debugPrint('下载失败，状态码: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('下载文件时发生错误: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        return Container(
          width: 360,
          alignment: Alignment.topLeft,
          child: ListView.builder(
              itemCount: chns.length,
              itemBuilder: (context, index) {
                return UnconstrainedBox(
                  alignment: Alignment.topLeft,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: Container(
                        color: Colors.white.withOpacity(0.2),
                        width: 360,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              idX = index;
                              debugPrint(chns[index].title);
                              showMyToast(chns[index].title);
                              player.setRate(1.0);
                              player.jump(index);
                              setState(() {
                                mainController.isPlayingOnlineVideo.value =
                                    true;
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.transparent),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                )),
                            child: Text(
                              chns[index].title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )),
                      )),
                );
              }),
        );
      },
    );
  }
}
