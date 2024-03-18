import 'package:flutter/material.dart';

class AIResultView extends StatelessWidget {
  const AIResultView({super.key, required this.apiResult});

  final String apiResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('A.I.')),
      body: Padding(
        padding: const EdgeInsets.all(27.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Here are some recipe ideas\nI came up with...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 400,
              margin: const EdgeInsets.only(top: 50.0, bottom: 30.0),
              padding: const EdgeInsets.only(left: 27.0, right: 27.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Text(
                  apiResult,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'))
          ],
        ),
      ),
    );
  }
}
