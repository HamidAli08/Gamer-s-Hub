// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/dashboard.dart';
import 'screens/cart.dart';
import 'screens/product_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/payment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: GamersHubApp(initialRoute: isLoggedIn ? '/dashboard' : '/login'),
    ),
  );
}

class GamersHubApp extends StatelessWidget {
  final String initialRoute;
  const GamersHubApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gamer's Hub",
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/cart': (_) => const CartScreen(),
        '/payment': (_) => const PaymentScreen(),

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
