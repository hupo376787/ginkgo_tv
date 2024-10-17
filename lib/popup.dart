import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ginkgo_tv/helper/toast_helper.dart';
import 'package:ginkgo_tv/main.dart';
import 'package:ginkgo_tv/model/channel.dart';

class PupupWidget extends StatefulWidget {
  const PupupWidget({super.key});

  @override
  State<PupupWidget> createState() => _PupupWidgetState();
}

class _PupupWidgetState extends State<PupupWidget> {
  final MainController mainController = Get.put(MainController());
  late List<Channel> chns = <Channel>[];

  Future<void> getData() async {
    if (chns.isNotEmpty) return;
    rootBundle
        .loadString("assets/file/channels.json")
        .then((value) => setState(() {
              debugPrint(value);
              chns = channelFromJson(value);

              chns =
                  chns.where((element) => element.videoUrl.isNotEmpty).toList();
            }));
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape: MaterialStateProperty.all<
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
