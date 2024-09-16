import 'package:flutter/material.dart';
import 'package:flutter_mortgage_calc/widgets/input_form.dart';
import 'package:flutter_mortgage_calc/widgets/instruction_panel.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiment',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(19, 48, 65, 1.0)),
          fontFamily: 'PlusJakartaSans'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(19, 48, 65, 1.0),
            title: const Text(
              "Mortgage Calculator",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.login, color: Colors.white),
                onPressed: () {
                  _dialogBuilder(context);
                },
              )
            ]),
        backgroundColor: Color.fromRGBO(228, 244, 253, 1.0),
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
                          Expanded(
                            child: Container(
                                height: 600.0,
                                padding: const EdgeInsets.all(40),
                                child: Center(child: MortgageForm())),
                          ),
                          const Expanded(child: InstructionPanel()),
                        ]))))));
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('User Login'),
            content: const Text("Login to view previous searches."),
            actions: [
              IconButton(
                icon: Icon(Icons.login, color: Colors.white),
                onPressed: () {
                  print(context);
                },
              )
            ]);
      });
}
