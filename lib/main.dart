import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/controller/event_controller.dart';
import 'package:tcc_project/controller/guide_controller.dart';
import 'package:tcc_project/controller/login_controller.dart';
import 'package:tcc_project/controller/phrase_controller.dart';
import 'package:tcc_project/controller/setting_controller.dart';
import 'package:tcc_project/my_app.dart';
import 'package:tcc_project/services/auth_service.dart';
import 'package:tcc_project/services/event_service.dart';
import 'package:tcc_project/services/guide_service.dart';
import 'package:tcc_project/services/phrase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  MapboxOptions.setAccessToken(
    "pk.eyJ1IjoiaXNhZG9yYWJ2IiwiYSI6ImNtZmg2amN4cTA3dnUybnB5NG0yemp4bTIifQ.VXBpfUI3DCtkYKZnkD1aWg",
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider<LoginController>(
          create: (context) =>
              LoginController()..updateAuthService(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<SettingController>(
          create: (context) =>
              SettingController(authService: context.read<AuthService>()),
        ),
        ChangeNotifierProvider<EventController>(
          create: (context) => EventController(EventService()),
        ),
        ChangeNotifierProvider<GuideController>(
          create: (context) => GuideController(service: GuideService()),
        ),
        ChangeNotifierProvider<PhraseController>(
          create: (context) => PhraseController(service: PhraseService()),
        ),
      ],
      child: MyApp(),
    ),
  );
}