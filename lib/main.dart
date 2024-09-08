import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:my_gemini/controller/chat_controller.dart';
import 'package:my_gemini/firebase_options.dart';
import 'package:my_gemini/screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Gemini.init(apiKey: "AIzaSyDwrIzXP35UpLvj7UumVYDMjsi67tEnMxc");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    return const GetMaterialApp(
      home: HomeScreen()
    );
  }
}
