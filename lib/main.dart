import 'package:flutter/material.dart';
import 'package:gamingstore/firebase_options.dart';
import 'package:provider/provider.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/dashboard.dart';
import 'screens/product_details.dart';
import 'screens/cart.dart';
import 'providers/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions, Firebase;
import 'package:flutter/foundation.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("🚀 This is the NEW Gamer's Hub code running!");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const GamersHubApp(),
    ),
  );
}

class GamersHubApp extends StatelessWidget {
  const GamersHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gamer's Hub",
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/cart': (_) => const CartScreen(),
        // product details we'll navigate with arguments
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product_details') {
          final args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(arguments: args),
          );
        }
        return null;
      },
    );
  }
}
