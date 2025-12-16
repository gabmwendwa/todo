// ignore_for_file: library_private_types_in_public_api

import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/bloc_category/categories_bloc.dart';
import 'dart:async';
import 'package:to_do/core/constants.dart';
import 'package:to_do/screen/index.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashscreen';

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> loadData() async {
    try {
      context.read<CategoriesBloc>().add(ReadCategories());
    } catch (e) {
      debugPrint("Exception: $e");
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    Future.delayed(
        const Duration(
          seconds: 3,
        ), () {
      Navigator.of(context).pushReplacementNamed(IndexScreen.routeName);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Center(
                    child: DropShadow(
                      blurRadius: 15.0,
                      color: Theme.of(context).primaryColorDark,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(150), // Image radius
                            child: Image.asset(mainAppLogo,
                                height: 400.0, width: 400.0, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DropShadow(
              blurRadius: 10.0,
              color: Theme.of(context).primaryColorDark,
              child: const Text(
                catchPhraseOne,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: appSubTitleFont,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Text(
              copyrightText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
