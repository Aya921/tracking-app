import 'package:flutter/material.dart';

class OrderDriverDetails extends StatelessWidget {
  const OrderDriverDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order details"),
        leading: const BackButton(),
      ),
    );
  }
}
