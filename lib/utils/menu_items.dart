import 'dart:io';

import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ginkgo_tv/main.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

class MenuItems {
  late List<ContextMenuEntry> entriesTV;
  late List<ContextMenuEntry> entriesDesktop;

  void initTVMenu() {
    entriesTV = <ContextMenuEntry>[
      MenuItem(
        label: '看电视模式',
        icon: Icons.live_tv,
        onSelected: () {
          player.open(onLineSources);
        },
      ),
      MenuItem(
        label: '打开本地媒体',
        icon: Icons.laptop,
        onSelected: () async {
          FilePickerResult? result =
              await FilePicker.platform.pickFiles(type: FileType.video);

          if (result != null) {
            List<Media> medias = <Media>[];
            final sources = Playlist(medias);
            medias.add(Media(result.files.single.path!));
            player.open(sources);
          } else {
            // User canceled the picker
          }
        },
      ),
      MenuItem(
        label: '打开在线流媒体',
        icon: Icons.ondemand_video,
        onSelected: () async {
          // singleInputDialog(
          //   null,
          //   "Single Input Dialog",
          //   DialogTextField(
          //       obscureText: false,
          //       textInputType: TextInputType.text,
          //       validator: (value) {},
          //       onEditingComplete: (value) {
          //         print(value);
          //       }),
          //   positiveButtonText: "Yes",
          //   positiveButtonAction: (value) {
          //     print(value);
          //   },
          //   negativeButtonText: "No",
          //   negativeButtonAction: () {},
          //   hideNeutralButton: false,
          //   closeOnBackPress: true,
          // );
        },
      )
    ];
  }

  void initDesktopMenus() {
    entriesDesktop = entriesTV;
    entriesDesktop.insert(
        0,
        MenuItem(
          label: '画中画模式',
          icon: Icons.picture_in_picture,
          onSelected: () async {
            if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
              var top = await windowManager.isAlwaysOnTop();
              windowManager.setAlwaysOnTop(!top);
              windowManager.setTitleBarStyle(
                  top ? TitleBarStyle.normal : TitleBarStyle.hidden);
            }
          },
        ));
  }

  //initialize a context menu
  ContextMenu dynamicMenu() {
    initTVMenu();
    initDesktopMenus();

    return ContextMenu(
      entries: Platform.isWindows || Platform.isLinux || Platform.isMacOS
          ? entriesDesktop
          : entriesTV,
      padding: const EdgeInsets.all(0.0),
    );
  }
}
