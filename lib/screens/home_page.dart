import 'package:flutter/material.dart';
import 'package:flutter_mortgage_calc/widgets/input_form.dart';
import 'package:flutter_mortgage_calc/widgets/instruction_panel.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(228, 244, 253, 1.0),
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
              child: const Row(children: [
                Expanded(
                  child: MortgageForm(),
                ),
                Expanded(child: InstructionPanel()),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
