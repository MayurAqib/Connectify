import 'package:connectify/provider/auth_provider.dart';
import 'package:connectify/provider/chat_provider.dart';
import 'package:connectify/provider/post_provider.dart';
import 'package:connectify/provider/profile_provider.dart';
import 'package:connectify/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'auth/auth_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
              titleMedium: GoogleFonts.montserrat(),
              bodyMedium: GoogleFonts.roboto()),
          colorScheme: ColorScheme.fromSeed(seedColor: darkDesign),
          useMaterial3: true,
        ),
        home: const AuthPage(),
      ),
    );
  }
}
