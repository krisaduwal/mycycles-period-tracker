
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:my_cycles/home_screen.dart';
import 'package:my_cycles/aboutus.dart';
import 'package:my_cycles/addPeriod.dart';
import 'package:my_cycles/auth/login.dart';
import 'package:my_cycles/feedback.dart';
import 'package:my_cycles/community.dart';
import 'package:my_cycles/healthtips.dart';
import 'package:my_cycles/logs.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

FirebaseFirestore fsi = FirebaseFirestore.instance;

const magenta = const Color(0x8e3a59);
int _currentIndex = 1;
int _pageIndex = 1;

var startDates = [];
var endDates = [];
var nextDate = [];
Map<String, dynamic> map = {};
Map<String, dynamic> selectedDateValue = {};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null) ? MyCycles() :
      LogIn(),
    ),
  );
}

