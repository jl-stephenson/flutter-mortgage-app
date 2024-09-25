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
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.25),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                    top: BorderSide(
                        color: Color.fromRGBO(216, 219, 47, 1), width: 3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 32),
                    const Divider(
                      color: Color.fromRGBO(154, 190, 213, 0.25),
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 32),
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
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
