
import 'package:flutter/material.dart';
import "package:get/get.dart";
class TransportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transport"),
        backgroundColor: Colors.orange[800],
      ),
      body: Center(
        child: Text(
          "Transport Information will be here",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}