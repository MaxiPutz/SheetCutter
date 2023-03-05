//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <page_detect_plugin/page_detect_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) page_detect_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "PageDetectPlugin");
  page_detect_plugin_register_with_registrar(page_detect_plugin_registrar);
}
