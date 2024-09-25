import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

class InstructionPanel extends StatelessWidget {
  const InstructionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.sizeOf(context).width;

    double fontSizeLarge = screenWidth < 950 ? 20 : 24;
    double verticalSpacing = screenWidth < 950 ? 12 : 16;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: 192.0,
              height: 192.0,
              child: WebsafeSvg.asset('assets/images/illustration-empty.svg')),
          SizedBox(
            height: verticalSpacing,
          ),
          Text("Results shown here",
              style: TextStyle(color: Colors.white, fontSize: fontSizeLarge)),
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
