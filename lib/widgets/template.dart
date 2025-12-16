import 'package:flutter/material.dart';
import 'package:to_do/core/constants.dart';

class MyTemplate extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget? drawer;
  final Widget wideLayout;
  final Widget narrowLayout;
  final Widget? floatingButton;
  const MyTemplate({
    super.key,
    required this.appBar,
    this.drawer,
    required this.wideLayout,
    required this.narrowLayout,
    this.floatingButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingButton,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return wideLayout;
                } else {
                  return narrowLayout;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        copyrightText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
