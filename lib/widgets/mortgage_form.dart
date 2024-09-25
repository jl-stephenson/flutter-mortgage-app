import 'package:flutter/material.dart';
import 'package:flutter_mortgage_calc/services/calculation.dart';
import 'package:provider/provider.dart';

enum MortgageType { repayment, interest }

class MortgageForm extends StatefulWidget {
  const MortgageForm({
    super.key,
  });

  @override
  MortgageFormState createState() {
    return MortgageFormState();
  }
}

class MortgageFormState extends State<MortgageForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final CalculationService calculationService = CalculationService();

  Future<void> _clearForm() async {
    _amountController.clear();
    _yearsController.clear();
    _interestController.clear();
    await context.read<CalculationService>().hideResults();
  }

  Future<void> _submitForm() async {
    double amount = double.parse(_amountController.text.replaceAll(',', ''));
    int years = int.parse(_yearsController.text);
    double interest = double.parse(_interestController.text);

    await context.read<CalculationService>().calculateRepayments(amount, years,
        interest, _selectedMortgageType.toString().split('.').last);
  }

  MortgageType? _selectedMortgageType = MortgageType.repayment;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.sizeOf(context).width;
    bool isSmallScreen = screenSize < 950;

    return Container(
      padding:
          isSmallScreen ? const EdgeInsets.all(24) : const EdgeInsets.all(40),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isSmallScreen
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            buildHeader(isSmallScreen),
            SizedBox(height: isSmallScreen ? 24 : 40),
            buildMortgageAmountField(),
            const SizedBox(height: 24),
            buildTermAndRateFields(isSmallScreen),
            SizedBox(height: isSmallScreen ? 24 : 30),
            buildMortgageTypeSection(),
            SizedBox(height: isSmallScreen ? 24 : 40),
            buildSubmitButton(context, isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(bool isSmallScreen) {
    return isSmallScreen
        ? Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Mortgage Calculator",
                    style: TextStyle(fontSize: 24)),
                TextButton(
                    onPressed: _clearForm,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                    ),
                    child: const Text('Clear all')),
              ],
            ),
          )
        : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Mortgage Calculator", style: TextStyle(fontSize: 24)),
            TextButton(
              onPressed: _clearForm,
              child: const Text('Clear all'),
            ),
          ]);
  }

  Widget buildMortgageAmountField() {
    return TextFormField(
        controller: _amountController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Mortgage Amount',
            prefixText: '£'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a mortgage amount';
          } else if (num.tryParse(value.replaceAll(',', '')) == null) {
            return 'Please enter a valid number';
          } else if (double.parse(value.replaceAll(',', '')) <= 0) {
            return 'Please enter a positive number';
          }
          return null;
        });
  }

  Widget buildTermAndRateFields(bool isSmallScreen) {
    return isSmallScreen
        ? Column(
            children: [
              buildTermField(),
              const SizedBox(height: 24),
              buildInterestRateField(),
            ],
          )
        : Row(
            children: [
              Expanded(child: buildTermField()),
              const SizedBox(width: 10),
              Expanded(child: buildInterestRateField()),
            ],
          );
  }

  Widget buildTermField() {
    return TextFormField(
      controller: _yearsController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Mortgage Term',
          suffixText: 'years'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a number of years';
        } else if (num.tryParse(value) == null) {
          return 'Please enter a valid number';
        } else if (int.parse(value) <= 0) {
          return 'Please enter a positive number';
        }
        return null;
      },
    );
  }

  Widget buildInterestRateField() {
    return TextFormField(
      controller: _interestController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Interest Rate',
          suffixText: '%'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an interest rate';
        } else if (num.tryParse(value) == null) {
          return 'Please enter a valid number';
        } else if (double.parse(value) <= 0) {
          return 'Please enter a positive number';
        }
        return null;
      },
    );
  }

  Widget buildMortgageTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Mortgage Type'),
        ),
        const SizedBox(height: 12),
        buildMortgageTypeOption(MortgageType.repayment, 'Repayment'),
        const SizedBox(height: 12),
        buildMortgageTypeOption(MortgageType.interest, 'Interest Only'),
      ],
    );
  }

  Widget buildMortgageTypeOption(MortgageType type, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black),
      ),
      child: Semantics(
        label: 'Mortgage Type: $label',
        child: ListTile(
          title: Text(label),
          leading: Radio<MortgageType>(
              value: type,
              groupValue: _selectedMortgageType,
              onChanged: (MortgageType? value) {
                setState(() {
                  _selectedMortgageType = value;
                });
              }),
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, bool isSmallScreen) {
    final button = ElevatedButton.icon(
      icon: const Icon(Icons.calculate),
      label: const Text('Calculate Repayments'),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          backgroundColor: const Color.fromRGBO(216, 219, 47, 1.0)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _submitForm();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );
        }
      },
    );

    return isSmallScreen
        ? SizedBox(width: double.infinity, child: button)
        : Align(alignment: Alignment.centerLeft, child: button);
  }
}
