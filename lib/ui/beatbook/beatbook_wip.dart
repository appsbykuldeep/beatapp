import 'package:flutter/material.dart';

class BeatBookWIP extends StatefulWidget {
  const BeatBookWIP({Key? key}) : super(key: key);

  @override
  State<BeatBookWIP> createState() => _BeatBookWIPState();
}

class _BeatBookWIPState extends State<BeatBookWIP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beat Book"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text("Work in Progress..."),
      ),
    );
  }
}
