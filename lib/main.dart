import 'dart:io';
import 'dart:convert';

import 'package:fialogs/fialogs.dart';
import 'package:ginkgo_tv/helper/toast_helper.dart';
import 'package:http/http.dart' as http;
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:get/get.dart';
import 'package:ginkgo_tv/model/channel.dart';
import 'package:ginkgo_tv/popup.dart';
import 'package:ginkgo_tv/splash_screen.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'utils/menu_items.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // 必须加上这一行。
    await windowManager.ensureInitialized();
  }

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://bb158a849e212c311c4c7d077e9db600@o4506782294671360.ingest.sentry.io/4506782299193344';
    },
    // Init your App.
    appRunner: () => runApp(GetMaterialApp(
      home: const SplashScreen(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    )),
  );
}

//Define controller
class MainController extends GetxController {
//节目菜单
  var isMenuVisible = false.obs;
//是否是播放在线视频流
  var isPlayingOnlineVideo = true.obs;
}
//End controller

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

final player = Player();
int idX = 0;
List<Channel> channels = <Channel>[];
var onLineSources = const Playlist(<Media>[]);
PupupWidget popup = const PupupWidget();

class _MainAppState extends State<MainApp> {
  final MainController mainController = Get.put(MainController());
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();

    downloadAndReadFile(
        'https://gitee.com/hupo376787/LiveList/raw/main/IPTV.m3u');
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> downloadAndReadFile(String url) async {
    List<Media> medias = <Media>[];
    onLineSources = Playlist(medias);

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
            channels.add(chl);
            medias.add(Media(chl.videoUrl[0]));
          }
        }

        player.open(onLineSources);
        player.setPlaylistMode(PlaylistMode.loop);
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

  late DragStartDetails startVerticalDragDetails;
  late DragUpdateDetails updateVerticalDragDetails;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (value) {
        if (value is KeyDownEvent) {
          switch (value.logicalKey.keyLabel) {
            case "Arrow Up":
              idX--;
              if (idX < 0) idX = channels.length - 1;
              player.previous();
              break;
            case "Arrow Down":
              idX++;
              if (idX > channels.length - 1) idX = 0;
              player.next();
              break;
            case "Enter":
              break;
            default:
          }

          //debugPrint(channels[idX].title);
          //showMyToast(channels[idX].title);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: ContextMenuRegion(
                  contextMenu: MenuItems().dynamicMenu(),
                  onItemSelected: (value) {
                    debugPrint(value);
                  },
                  child: GestureDetector(
                    onVerticalDragStart: (dragDetails) {
                      startVerticalDragDetails = dragDetails;
                    },
                    onVerticalDragUpdate: (dragDetails) {
                      updateVerticalDragDetails = dragDetails;
                    },
                    onVerticalDragEnd: (endDetails) {
                      double dy = updateVerticalDragDetails.globalPosition.dy -
                          startVerticalDragDetails.globalPosition.dy;

                      if (dy < 0) {
                        player.next();
                      } else {
                        player.previous();
                      }
                    },
                    onTap: () {
                      setState(() {
                        mainController.isMenuVisible = RxBool(false);
                      });
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 9.0 / 16.0,
                      child: Video(
                        controller: controller,
                        //isPlayingOnlineVideo更改不会刷新，需要解决
                        controls: mainController.isPlayingOnlineVideo.value
                            ? NoVideoControls
                            : AdaptiveVideoControls,
                      ),
                    ),
                  )),
            ),
            Visibility(
              visible: mainController.isMenuVisible.value,
              maintainState: true,
              child: popup,
            ),
            IconButton(
              onPressed: () async {
                setState(() {
                  mainController.isMenuVisible.toggle();
                });
              },
              icon: const Icon(Icons.menu),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
