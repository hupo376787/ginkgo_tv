import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ginkgo_tv/helper/toast_helper.dart';
import 'package:ginkgo_tv/model/channel.dart';
import 'package:ginkgo_tv/splash_screen.dart';

import 'package:http/http.dart' as http;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';

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
    appRunner: () => runApp(MaterialApp(
      home: const SplashScreen(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    )),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final player = Player();
  late final controller = VideoController(player);
  String? channelContent;

  @override
  void initState() {
    super.initState();

    rootBundle
        .loadString("assets/file/channels.json")
        .then((value) => setState(() {
              debugPrint(value);
              channelContent = value;

              List<Media> medias = <Media>[];
              final sources = Playlist(medias);
              final channels = channelFromJson(channelContent!);
              for (int i = 0; i <= channels.length - 1; i++) {
                if (channels[i].videoUrl.isNotEmpty) {
                  medias.add(Media(channels[i].videoUrl[0]));
                }
              }
              player.open(sources);
              player.setPlaylistMode(PlaylistMode.loop);
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
            default:
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 9.0 / 16.0,
                child: Video(
                  controller: controller,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                if (Platform.isWindows ||
                    Platform.isLinux ||
                    Platform.isMacOS) {
                  var top = await windowManager.isAlwaysOnTop();
                  windowManager.setAlwaysOnTop(!top);
                  windowManager.setTitleBarStyle(
                      top ? TitleBarStyle.normal : TitleBarStyle.hidden);
                }
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
