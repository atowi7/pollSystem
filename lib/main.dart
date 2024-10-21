import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poll_system/app_routes.dart';
import 'package:poll_system/providers/poll_provider.dart';
import 'package:poll_system/providers/user_provider.dart';
import 'package:poll_system/views/home_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PollProvider()),
      ],
      child: MaterialApp(
        title: 'Poll System',
        theme: ThemeData(
            // primaryColor: Colors.indigo,
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.w900),
              displayMedium: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
              displaySmall: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w200),
            )),
        navigatorKey: navigatorKey,
        home: const HomeScreen(),
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
