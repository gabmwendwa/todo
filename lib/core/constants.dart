// ignore_for_file: prefer_typing_uninitialized_variables, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//  ------- COMMON CONSTANT VARIABLES START -------

final DateTime dateTimeNow = DateTime.now();
final int dateTimeYear = dateTimeNow.year;
final int dateTimeMonth = dateTimeNow.month;
final int dateTimeDay = dateTimeNow.day;
const String companyName = 'Gabriel Mwendwa';
String mainAppName = 'To Do';
const String mainAppSlogan = 'Stay Organized';
const String mainAppLogo = 'assets/images/logo/android/logo.png';
const String profilePlaceholder = 'assets/images/placeholders/avatar.png';
final String copyrightText = '$dateTimeYear \u00A9 $companyName';
const String versionText = ''; // 'v1.1.0';
const String catchPhraseOne = 'I am organized!';
const String appTitleFont = 'FredokaOne';
const String appSubTitleFont = 'Pacifico';

//  ------- DEFAULT TIME VALUES START -------

humanReadableDateTime(String sts) {
  final dateTime = DateTime.parse(sts).toUtc();
  String formatted = DateTimeFormat.format(dateTime, format: 'D, j M Y, h:ia');

  return formatted;
}

//  ------- DEFAULT TIME VALUES END -------

final List drawerList = [
  {
    'icon': Icon(
      Platform.isIOS ? CupertinoIcons.home : Icons.home_filled,
    ),
    'label': 'Home',
  },
  {
    'icon': Icon(
      Platform.isIOS ? CupertinoIcons.square_list : Icons.list_alt_rounded,
    ),
    'label': 'Upcoming',
  },
  {
    'icon': Icon(
      Platform.isIOS ? CupertinoIcons.calendar : Icons.calendar_month_rounded,
    ),
    'label': 'Calendar',
  },
  {
    'icon': Icon(
      Platform.isIOS ? CupertinoIcons.settings : Icons.settings,
    ),
    'label': 'Settings',
  },
];

//  ------- DOUBLE TO INT START -------

int doubletoint(ranks) {
  double multiplier = .5;
  return (multiplier * ranks).round();
}

//  ------- DOUBLE TO INT END -------

const List<Color> myBGGradient = [
  Color(0xFF05182D),
  Color(0xFF092A45),
  Color(0xFF0D2339)
];

final List<String> arrangeList = <String>['Latest', 'Oldest'];

final List<String> priorityList = <String>[
  '1',
  '2',
  '3',
];
final List<String> priorityLabelList = <String>[
  'High',
  'Medium',
  'Low',
];
