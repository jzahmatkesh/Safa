//
// Generated file. Do not edit.
//

// ignore: unused_import
import 'dart:ui';

import 'package:file_picker/src/file_picker_web.dart';
import 'package:printing/src/printing_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(PluginRegistry registry) {
  FilePickerWeb.registerWith(registry.registrarFor(FilePickerWeb));
  PrintingPlugin.registerWith(registry.registrarFor(PrintingPlugin));
  SharedPreferencesPlugin.registerWith(registry.registrarFor(SharedPreferencesPlugin));
  UrlLauncherPlugin.registerWith(registry.registrarFor(UrlLauncherPlugin));
  registry.registerMessageHandler();
}
