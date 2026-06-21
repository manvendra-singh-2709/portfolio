//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <app_links/app_links_plugin_c_api.h>
#include <flutter_any_logo/flutter_any_logo_plugin_c_api.h>
#include <passkeys_windows/passkeys_windows_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AppLinksPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AppLinksPluginCApi"));
  FlutterAnyLogoPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterAnyLogoPluginCApi"));
  PasskeysWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PasskeysWindowsPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
