import 'package:flutter/material.dart';

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

  MortgageType? _character = MortgageType.repayment;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Mortgage Calculator", style: TextStyle(fontSize: 24)),
              ElevatedButton(
                onPressed: () {
                  print("Clicked!");
                },
                child: const Text('Clear all'),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mortgage Amount',
                  prefixText: '£'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a mortgage amount';
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
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mortgage Term',
                          suffixText: 'years'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a number of years';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Interest Rate',
                          suffixText: '%'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an interest rate';
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
          Align(
              alignment: Alignment.centerLeft,
              child: const Text('Mortgage Type')),
          const SizedBox(
            height: 12,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black)),
            child: ListTile(
              title: const Text('Repayment'),
              leading: Radio<MortgageType>(
                  value: MortgageType.repayment,
                  groupValue: _character,
                  onChanged: (MortgageType? value) {
                    setState(() {
                      _character = value;
                    });
                  }),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black)),
            child: ListTile(
              title: const Text('Interest Only'),
              leading: Radio<MortgageType>(
                  value: MortgageType.interest,
                  groupValue: _character,
                  onChanged: (MortgageType? value) {
                    setState(() {
                      _character = value;
                    });
                  }),
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
                backgroundColor: Color.fromRGBO(216, 219, 47, 1.0),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
