import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:plant_match_v2/app.dart';
import 'package:plant_match_v2/firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //FlutterNativeSplash.remove();
  Future.delayed(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
  });
  runApp(MyApp());
}
