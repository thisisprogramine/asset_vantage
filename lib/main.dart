


import 'dart:async';
import 'dart:io';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:asset_vantage/src/domain/usecases/performance/get_performance_primary_grouping.dart';
import 'package:asset_vantage/src/injector.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:asset_vantage/src/utilities/helper/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:newrelic_mobile/config.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:queue/queue.dart';
import 'src/injector.dart' as getIt;
import 'src/presentation/av_app.dart';
import 'package:newrelic_mobile/newrelic_mobile.dart';

final ipsResponseQueue = Queue();
final cbResponseQueue = Queue();
final nwResponseQueue = Queue();
final perResponseQueue = Queue();
final ieResponseQueue = Queue();

String _getAppToken() {
  var appToken = "";
  if (Platform.isIOS) {
    appToken = 'AA7efab293c6788d87e8185baae29acbb17c339b77-NRMA';
  } else if (Platform.isAndroid) {
    appToken = 'AAfd161ccd7da0fa080a641a9b4689e5db8812cbc4-NRMA';
  }

  return appToken;
}

Config config = Config(
  accessToken: _getAppToken(),
  analyticsEventEnabled: true,
  networkErrorRequestEnabled: true,
  networkRequestEnabled: true,
  crashReportingEnabled: true,
  interactionTracingEnabled: true,
  httpResponseBodyCaptureEnabled: true,
  loggingEnabled: true,
  webViewInstrumentation: true,
  printStatementAsEventsEnabled : true,
  httpInstrumentationEnabled:true,
  fedRampEnabled: true,
  offlineStorageEnabled: true,
  backgroundReportingEnabled: true,
  newEventSystemEnabled: true,
  distributedTracingEnabled: true,
);

Future<void> main() async{

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    unawaited(SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]));

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: AppColor.lightGrey,
        )
    );

    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    await getIt.init();

    FlutterError.onError = NewrelicMobile.onError;
    await NewrelicMobile.instance.startAgent(config);
    runApp(const AssetVantageApp());
  }, (Object error, StackTrace stackTrace) {
    NewrelicMobile.instance.recordError(error, stackTrace);
  });
}