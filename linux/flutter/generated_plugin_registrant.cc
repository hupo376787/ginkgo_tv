//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <media_kit_libs_linux/media_kit_libs_linux_plugin.h>
#include <media_kit_video/media_kit_video_plugin.h>
#include <screen_retriever_linux/screen_retriever_linux_plugin.h>
#include <sentry_flutter/sentry_flutter_plugin.h>
#include <window_manager/window_manager_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) media_kit_libs_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MediaKitLibsLinuxPlugin");
  media_kit_libs_linux_plugin_register_with_registrar(media_kit_libs_linux_registrar);
  g_autoptr(FlPluginRegistrar) media_kit_video_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MediaKitVideoPlugin");
  media_kit_video_plugin_register_with_registrar(media_kit_video_registrar);
  g_autoptr(FlPluginRegistrar) screen_retriever_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ScreenRetrieverLinuxPlugin");
  screen_retriever_linux_plugin_register_with_registrar(screen_retriever_linux_registrar);
  g_autoptr(FlPluginRegistrar) sentry_flutter_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SentryFlutterPlugin");
  sentry_flutter_plugin_register_with_registrar(sentry_flutter_registrar);
  g_autoptr(FlPluginRegistrar) window_manager_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WindowManagerPlugin");
  window_manager_plugin_register_with_registrar(window_manager_registrar);
}
