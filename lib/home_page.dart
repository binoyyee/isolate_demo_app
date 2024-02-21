import 'dart:isolate';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 90,
              ),
              Image.asset('assets/gifs/bouncing-ball.gif'),
              //Blocking UI Task
              ElevatedButton(
                onPressed: () async {
                  var total = await complexTask11();
                  debugPrint('Result 1: $total');
                },
                child: const Text('Task 1'),
              ),
              //Isolate
              ElevatedButton(
                onPressed: () async {
                  final receiveport = ReceivePort();
                  await Isolate.spawn(complexTask2, receiveport.sendPort);
                  //await used is not for response, but just to create isolate
                  receiveport.listen((total) {
                    debugPrint('Result 2: $total');
                  });
                },
                child: const Text('Task 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double complexTask1() {
    var total = 0.0;
    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }

  //Made future method to use async-await in above ElevatedButton 1, but doesn't help
  Future<double> complexTask11() async {
    var total = 0.0;
    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}
// End of Home Page

//Method to be executed in Isolate should be out of any class so that it can run independently
complexTask2(SendPort sendPort) {
  var total = 0.0;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}
