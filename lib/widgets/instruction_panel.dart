import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

class InstructionPanel extends StatelessWidget {
  const InstructionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WebsafeSvg.asset('assets/images/illustration-empty.svg'),
          const SizedBox(
            height: 16,
          ),
          const Text("Results shown here",
              style: TextStyle(color: Colors.white, fontSize: 24)),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Complete the form and click "calculate repayments" to see what your monthly repayments would be.',
            style: TextStyle(
                color: Color.fromRGBO(154, 190, 213, 1.0), fontSize: 16),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
