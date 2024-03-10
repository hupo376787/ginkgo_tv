import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final player = Player();
  late final controller = VideoController(player);
  final sources = Playlist(
    [
      Media(
          "http://[2409:8087:7000:20::4]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226231/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::6]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226195/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::7]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226397/index.m3u8"),
      Media(
          "http://[2409:8087:7000:20::204]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226191/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::5]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226395/index.m3u8"),
      Media(
          "http://[2409:8087:7000:20::203]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221225761/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::7]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226393/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::4]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226192/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::8]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226391/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::4]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226197/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::2]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226189/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::5]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226240/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::6]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226190/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::2]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226233/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::2]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226193/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::4]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221225785/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::9]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226921/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:3::5]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226198/index.m3u8"),
      Media(
          "http://[2409:8087:2001:20:2800:0:df6e:eb13]:80/ott.mobaibox.com/PLTV/3/224/3221228228/index.m3u8"),
      Media(
          "http://[2409:8087:2001:20:2800:0:df6e:eb03]:80/ott.mobaibox.com/PLTV/4/224/3221228165/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226465/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226462/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221226463/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226975/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226972/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226947/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226981/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226956/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226978/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226950/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226953/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226959/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226969/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226984/index.m3u8"),
      Media(
          "http://[2409:8087:7001:20:2::3]:80/dbiptv.sn.chinamobile.com/PLTV/88888893/224/3221226987/index.m3u8"),
      Media(
          "http://[2409:8087:7000:20::4]:80/dbiptv.sn.chinamobile.com/PLTV/88888888/224/3221225745/index.m3u8"),
      Media(
          "http://[2409:8087:7000:20:1000::22]:6060/yinhe/2/ch00000090990000002905/index.m3u8?virtualDomain=yinhe.live_hls.zte.com"),
      Media(
          "http://[2409:8087:7000:20:1000::22]:6060/yinhe/2/ch00000090990000002883/index.m3u8?virtualDomain=yinhe.live_hls.zte.com"),
      Media(
          "http://[2409:8087:7000:20:1000::22]:6060/yinhe/2/ch00000090990000002827/index.m3u8?virtualDomain=yinhe.live_hls.zte.com"),
      Media(
          "http://[2409:8087:7000:20:1000::22]:6060/yinhe/2/ch00000090990000002716/index.m3u8?virtualDomain=yinhe.live_hls.zte.com"),
      Media(
          "http://[2409:8087:7000:20:1000::22]:6060/yinhe/2/ch00000090990000002826/index.m3u8?virtualDomain=yinhe.live_hls.zte.com"),
    ],
  );

  @override
  void initState() {
    super.initState();
    var res = getData();
    res.then((value) => {
          if (value) {} else {player.open(sources)}
        });
    player.setPlaylistMode(PlaylistMode.loop);
  }

  Future<bool> getData() async {
    var res = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/hupo376787/Livelist/main/CCTV.m3u'));
    if (res.statusCode == 200) {
      sources.medias.clear();
      res.body.split('\n').forEach((element) {
        if (element.startsWith('http:')) {
          sources.medias.add(Media(element));
        }
      });
      player.open(sources);

      return Future<bool>.value(true);
    }

    return Future<bool>.value(false);
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
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 9.0 / 16.0,
                child: Video(
                  controller: controller,
                ),
              ),
            ),
          ),
        ));
  }
}
