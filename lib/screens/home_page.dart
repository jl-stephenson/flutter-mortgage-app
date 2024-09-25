import 'package:flutter/material.dart';
import 'package:flutter_mortgage_calc/screens/sign_in_screen.dart';
import 'package:flutter_mortgage_calc/services/auth.dart';
import 'package:flutter_mortgage_calc/services/calculation.dart';
import 'package:flutter_mortgage_calc/widgets/mortgage_form.dart';
import 'package:flutter_mortgage_calc/widgets/instruction_panel.dart';
import 'package:flutter_mortgage_calc/widgets/results_panel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

    var screenSize = MediaQuery.sizeOf(context);
    double cardWidth = screenSize.width * 0.8;
    double cardHeight = screenSize.height * 0.7;
    bool isSmallScreen = screenSize.width < 950;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(228, 244, 253, 1.0),
      appBar: isSmallScreen
          ? null
          : AppBar(
              backgroundColor: const Color.fromRGBO(228, 244, 253, 1.0),
              actions: [
                ElevatedButton(
                  onPressed: () => _signOut(),
                  child: const Text("Sign Out"),
                ),
              ],
            ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: isSmallScreen ? double.infinity : 600.0,
          ),
          child: Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: cardWidth > 1000.0 ? 1000.0 : cardWidth,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return isSmallScreen
                        ? buildColumnLayout(isResults)
                        : buildRowLayout(isResults);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: isSmallScreen
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _signOut(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: const Color.fromRGBO(216, 219, 47, 1.0),
                ),
                child: const Text("Sign Out"),
              ),
            )
          : null,
    );
  }

  Widget buildRowLayout(bool isResults) {
    return Row(children: [
      const Expanded(
        child: MortgageForm(),
      ),
      Expanded(
        child: buildPanelContainer(isResults, isSmallScreen: false),
      )
    ]);
  }

  Widget buildColumnLayout(bool isResults) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const MortgageForm(),
          buildPanelContainer(isResults, isSmallScreen: true),
        ],
      ),
    );
  }

  Widget buildPanelContainer(bool isResults, {required bool isSmallScreen}) {
    return Container(
      height: isSmallScreen ? null : double.infinity,
      padding:
          isSmallScreen ? const EdgeInsets.all(24) : const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(19, 48, 65, 1.0),
        borderRadius: isSmallScreen
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0))
            : const BorderRadius.only(
                bottomLeft: Radius.circular(100.0),
              ),
      ),
      child: isResults ? const ResultsPanel() : const InstructionPanel(),
    );
  }
}
