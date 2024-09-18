import 'package:flutter/material.dart';
import 'package:flutter_mortgage_calc/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_mortgage_calc/services/calculation.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculationService()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculationService(),
      child: MaterialApp(
        title: 'Mortgage Calculator',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(19, 48, 65, 1.0)),
            fontFamily: 'PlusJakartaSans'),
        home: const SignInScreen(),
      ),
    );
  }
}
