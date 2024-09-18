import 'package:flutter/material.dart';
import 'package:flutter_mortgage_calc/screens/sign_in_screen.dart';
import 'package:flutter_mortgage_calc/services/auth.dart';
import 'package:flutter_mortgage_calc/services/calculation.dart';
import 'package:flutter_mortgage_calc/widgets/input_form.dart';
import 'package:flutter_mortgage_calc/widgets/instruction_panel.dart';
import 'package:flutter_mortgage_calc/widgets/results_panel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();

  Future<void> _signOut() async {
    await _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isResults = context.watch<CalculationService>().isResults;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(228, 244, 253, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(228, 244, 253, 1.0),
        actions: [
          ElevatedButton(
            onPressed: () => _signOut(),
            child: const Text("Sign Out"),
          ),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 1000.0,
              height: 600.0,
              child: Row(children: [
                const Expanded(
                  child: MortgageForm(),
                ),
                Expanded(
                  child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(19, 48, 65, 1.0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                        ),
                      ),
                      child: isResults ? ResultsPanel() : InstructionPanel()),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
