import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const GuessMyNumber());
}

/// Generates random integer number.
int generateNumber() {
  final Random random = Random();
  return random.nextInt(100);
}

/// Returns appropriate message based on the values compared to each other.
String checkNumber(int? inputValue, int randomValue) {
  if (inputValue! < randomValue) {
    return 'Try higher!';
  } else if (inputValue > randomValue) {
    return 'Try lower!';
  } else {
    return 'You guessed right!🎉';
  }
}

/// Spawns message if the user sent an input.
Widget guessedNumber({required bool state, required int? inputValue, required int randomValue}) {
  if (state && inputValue != null) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        children: <Widget>[
          Text(
            'You tried $inputValue!',
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              color: Color(0xff000000),
              fontSize: 20,
            ),
          ),
          Text(
            checkNumber(inputValue, randomValue),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xffb5838d),
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  } else {
    return Container();
  }
}

class GuessMyNumber extends StatelessWidget {
  const GuessMyNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: const Color(0xfff8edeb),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xffcb8589), centerTitle: true),
        fontFamily: 'Montserrat',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool state = false;

  final TextEditingController controller = TextEditingController();
  String? typeError;

  int? inputValue;
  int? tryValue;
  int randomValue = generateNumber();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guess my number')),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Text(
              "I'm thinking of a number between 1 and 100.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Text(
              "It's your turn to guess my number!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          guessedNumber(state: state, inputValue: inputValue, randomValue: randomValue),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Card(
              color: const Color(0xfffffbfb),
              elevation: 3,
              child: SizedBox(
                width: 350,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Text(
                        'Try a number!🌈',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          // hintText: 'Please enter a number',
                          errorText: typeError,
                        ),
                        onChanged: (String input) {
                          setState(() {
                            if (input == '') {
                              tryValue = null;
                              typeError = null;
                            } else {
                              tryValue = int.tryParse(input);
                              if (tryValue == null) {
                                typeError = 'Enter a valid number';
                              } else {
                                typeError = null;
                              }
                            }
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  if (tryValue != null) {
                                    inputValue = tryValue;
                                    state = true;
                                  } else {
                                    state = false;
                                  }
                                });

                                if (inputValue == randomValue) {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'You guessed right!🎉',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        content: Text(
                                          'It was $inputValue!',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                state = false;
                                                randomValue = generateNumber();
                                              });
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text(
                                              'Try Again',
                                              style: TextStyle(color: Colors.lightBlue),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                            child: const Text(
                                              'Close',
                                              style: TextStyle(color: Colors.lightBlue),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(backgroundColor: const Color(0xff8c2f39)),
                              child: const Text(
                                'Send',
                                style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffffffff)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  state = false;
                                  randomValue = generateNumber();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xfff0e5e1),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xff8c2f39)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
