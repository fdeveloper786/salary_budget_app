import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Data/Core/Utils/initial_bindings.dart';
import 'package:salary_budget/Data/Core/Utils/logger.dart';
import 'package:salary_budget/Domain/AppRoutes/routes.dart';
import 'package:salary_budget/repository/authenticaion_repository.dart';

bool? isLoggedIn;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: apiKey,
      authDomain: authDomain,
      projectId: projectId,
      storageBucket: storageBucketId,
      messagingSenderId: messageSenderId,
      appId: appId,
      measurementId: measurementId,
    )).then((value) => Get.put(AuthenticationRepository()));
  } else {
    await Firebase.initializeApp()
        .then((value) => Get.put(AuthenticationRepository()));
  }

  isLoggedIn = await AuthenticationRepository.instance.isUserLoggedIn();
  print('is user logged in ${isLoggedIn}');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    FlutterNativeSplash.remove();
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Salary Budget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: InitialBindings(),
      initialRoute: isLoggedIn! ? AppRoutes.homeScreen : AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
