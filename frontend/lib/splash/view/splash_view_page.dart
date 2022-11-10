import 'package:flutter/material.dart';

class SplashViewPage extends StatelessWidget {
  const SplashViewPage({super.key});

  static const String url = '/';

  final Gradient _gradient = const LinearGradient(
    colors: [Colors.yellow, Colors.pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Expanded(
          //   child: Center(
          //       child: Image.asset(
          //     'assets/images/icon_logo.png',
          //     width: 100,
          //   )),
          // ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
            child: Column(
              children: const [
                Text(
                  'from',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
