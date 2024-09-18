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
    return Container(
      height: 600.0,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Mortgage Calculator",
                      style: TextStyle(fontSize: 24)),
                  TextButton(
                    onPressed: _clearForm,
                    child: const Text('Clear all'),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mortgage Amount',
                      prefixText: '£'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a mortgage amount';
                    } else if (num.tryParse(value.replaceAll(',', '')) ==
                        null) {
                      return 'Please enter a valid number';
                    } else if (double.parse(value.replaceAll(',', '')) <= 0) {
                      return 'Please enter a positive number';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
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
                          }),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
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
                          }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Mortgage Type')),
              const SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.black)),
                child: Semantics(
                  label: 'Mortgage Type: Repayment',
                  child: ListTile(
                    title: const Text('Repayment'),
                    leading: Radio<MortgageType>(
                        value: MortgageType.repayment,
                        groupValue: _selectedMortgageType,
                        onChanged: (MortgageType? value) {
                          setState(() {
                            _selectedMortgageType = value;
                          });
                        }),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.black)),
                child: Semantics(
                  label: 'Mortgage Type: Interest Only',
                  child: ListTile(
                    title: const Text('Interest Only'),
                    leading: Radio<MortgageType>(
                        value: MortgageType.interest,
                        groupValue: _selectedMortgageType,
                        onChanged: (MortgageType? value) {
                          setState(() {
                            _selectedMortgageType = value;
                          });
                        }),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Processing Data")),
                      );
                    }
                  },
                  icon: const Icon(Icons.calculate),
                  label: const Text("Calculate Repayments"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 20.0),
                    backgroundColor: const Color.fromRGBO(216, 219, 47, 1.0),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _yearsController.dispose();
    _interestController.dispose();
    super.dispose();
  }
}
