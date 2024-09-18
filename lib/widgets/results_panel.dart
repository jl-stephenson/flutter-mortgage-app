import 'package:flutter/material.dart';
import 'package:flutter_mortgage_calc/services/calculation.dart';
import 'package:provider/provider.dart';

class ResultsPanel extends StatelessWidget {
  const ResultsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    String monthlyRepayment =
        context.watch<CalculationService>().formattedMonthlyRepayment;
    String totalRepayment =
        context.watch<CalculationService>().formattedTotalRepayment;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your results',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            )),
        const SizedBox(height: 16),
        const Text(
          'Your results are shown below based on the information you provided. To adjust the results, edit the form and click "calculate repayments" again.',
          style: TextStyle(color: Color.fromRGBO(154, 190, 213, 1)),
        ),
        const SizedBox(height: 72),
        const Text(
          'Your monthly repayments',
          style: TextStyle(color: Color.fromRGBO(154, 190, 213, 1)),
        ),
        const SizedBox(height: 8),
        Text(
          '£$monthlyRepayment',
          style: const TextStyle(
            color: Color.fromRGBO(216, 219, 47, 1),
            fontSize: 56,
          ),
        ),
        const SizedBox(height: 65),
        const Text(
          'Total you\'ll repay over the term',
          style: TextStyle(color: Color.fromRGBO(154, 190, 213, 1)),
        ),
        const SizedBox(height: 8),
        Text(
          '£$totalRepayment',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
