import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
late List<Channel> channels;
var onLineSources = const Playlist(<Media>[]);
PupupWidget popup = const PupupWidget();

class _MainAppState extends State<MainApp> {
  final MainController mainController = Get.put(MainController());
  late final controller = VideoController(player);
  String? channelContent;

  @override
  void initState() {
    super.initState();

    rootBundle
        .loadString("assets/file/channels.json")
        .then((value) => setState(() async {
              debugPrint(value);
              channelContent = value;

              List<Media> medias = <Media>[];
              onLineSources = Playlist(medias);
              channels = channelFromJson(channelContent!);
              for (int i = 0; i <= channels.length - 1; i++) {
                if (channels[i].videoUrl.isNotEmpty) {
                  medias.add(Media(channels[i].videoUrl[0]));
                }
              }
              player.open(onLineSources);
              player.setPlaylistMode(PlaylistMode.loop);

              // if (player.platform is NativePlayer) {
              // } else {
              //   await (player.platform as dynamic).setProperty('cache', 'no');
              // }
            }));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (value) {
        if (value is RawKeyDownEvent) {
          switch (value.logicalKey.keyLabel) {
            case "Arrow Up":
              player.previous();
              break;
            case "Arrow Down":
              player.next();
              break;
            case "Enter":
              break;
            default:
          }
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
                  child: InkWell(
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
