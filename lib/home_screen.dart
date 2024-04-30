
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:my_cycles/aboutus.dart';
import 'package:my_cycles/addPeriod.dart';
import 'package:my_cycles/auth/login.dart';
import 'package:my_cycles/feedback.dart';
import 'package:my_cycles/community.dart';
import 'package:my_cycles/healthtips.dart';
import 'package:my_cycles/logs.dart';
import 'package:intl/intl.dart';
import 'package:my_cycles/nextPeriodPrediction.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'main.dart';

class MyCycles extends StatefulWidget {
  _MyCycleState createState() => _MyCycleState();
}

class _MyCycleState extends State<MyCycles> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  // const magenta = const Color(0x8e3a59);
  int _currentIndex = 1;
  int _pageIndex = 1;

  DateTime today = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  var valueArray = [];
  var dateArray = [];
  Set<DateTime> _estimatedNextPeriods = {};
  Map<String, dynamic> map = {};
  String value = '';
  String date = '';
  String nextPeriod = "";
  late CalendarController _controller;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  TextEditingController _textFieldController = TextEditingController();
  final List<Widget> _children = [Community(), MyCycles(), AboutUs()];
  bool _initialized = false;
  bool _error = false;
  String nextPeriodPrediction = '';
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  // ignore: non_constant_identifier_names
  _OnTap() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => _children[_currentIndex]));
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    initializeFlutterFire();
    _getPeriodData();
    _selectedDay = _focusedDay;
    print("love");
    print(FirebaseAuth.instance.currentUser?.email);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay){
    if(!isSameDay(_selectedDay, _selectedDay)){
      setState(() {
        _selectedDay = _selectedDay;
        _focusedDay = focusedDay;
      }); //for day selection
    }
  }

  // void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay){
  //   setState(() {
  //     _selectedDay = null;
  //     _focusedDay = focusedDay;
  //     _rangeStart = start;
  //     _rangeEnd = end;
  //   });
  // }

  _getPeriodData() async {
    String? user = FirebaseAuth.instance.currentUser?.email;
    FirebaseFirestore.instance
        .collection("periodinfo")
        .where("user",isEqualTo: user)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print("hello ");
        print(result.data());
        map = result.data();
        setState(() {
          nextPeriod = map['Selected Date']['next'];
        });
        DateTime date = DateTime.parse(map['Selected Date']['start']);
        String month = date.month < 10?"0${date.month}":"${date.month}";
        DateTime newDate = DateTime.parse("${date.year}-${month}-${date.day} 00:00:00.000Z").toUtc();
        Set<DateTime> temp = {};

        for(int i = 0 ;i < 5 ;i++)
          {
            newDate = newDate.add(Duration(days: map['Cycle Length']));
            temp.add(newDate);
          }
        setState(() {
          _estimatedNextPeriods = temp;
        });

        // selectedDateValue = map['Selected Date'];
        // var temp1 = DateFormat('yyyy-MM-dd').parse(selectedDateValue['start']);
        // startDates.add(temp1);
        // var temp2 = DateFormat('yyyy-MM-dd').parse(selectedDateValue['end']);
        // endDates.add(temp2);
        // var temp3 = DateFormat('yyyy-MM-dd').parse(selectedDateValue['nextperiod']);
        // nextDate.add(temp2);
        // print(startDates);
        // print(endDates);
        // print(nextDate);
      });
    });
  }


  _getStartDate() {
    if (startDates.length > 0) {
      print('here');
      print(startDates[0]);
      print(startDates);
      return startDates[0];
    } else {
      return null;
    }
  }

  _getEndDate() {
    if (startDates.length > 0) {
      return endDates[0];
    } else {
      return null;
    }
  }
  //
  // _getNextDate() {
  //   if(nextDate.length > 0) {
  //     return nextDate[0];
  //
  //   }
  //   else {
  //     return null;
  //   }
  // }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) => LogIn()
    ));
  }

  Future<void> calculateNextPeriod() async {

    log("next period is around");
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('periodinfo')
          .doc('CDhLn8K7LgeFcxmzaiOSDMmXvIh2')
          .get();

      //retrieve last period end date from firestore
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      Timestamp lastPeriodEndDate = userData['lastPeriodEndDate.toDate'];

      //calculate next period prediction based on last period end date
      DateTime lastPeriodEndDateTime = lastPeriodEndDate.toDate();
      DateTime nextPeriodPredictionDateTime = lastPeriodEndDateTime.add(Duration(days: 28));

      String formattedPrediction = '${nextPeriodPredictionDateTime.day}/${nextPeriodPredictionDateTime.month}/${
          nextPeriodPredictionDateTime.year
      }';
      setState(() {
        nextPeriodPrediction = formattedPrediction;
      });
    } catch (error){
      print('Error calculating next period prediction: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            new SizedBox(
              height: 100.0,
              width: 80.0,
              child: new IconButton(
                  icon: Image.asset('assets/finallogo.png'), onPressed: () => {}),
            ),
          ],
          title: Text(
            "Naari Saathi",
            style: TextStyle(fontFamily: 'Allura', fontSize: 30),
          ),
          backgroundColor: Colors.purple.shade100,
          centerTitle: true,
          elevation: 5.0,
        ),
        body: SingleChildScrollView(
          child: new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment(-1.0, 0.0),
              //   end: Alignment(1.0, 0.0),
              //   stops: [
              //     0.0,
              //     0.1,
              //     0.1,
              //     0.2,
              //     0.2,
              //     0.3,
              //     0.3,
              //     0.4,
              //     0.4,
              //     0.5,
              //     0.5,
              //     0.6,
              //     0.6,
              //     0.7,
              //     0.7,
              //     0.8,
              //     0.8,
              //     0.9,
              //     0.9,
              //     1
              //   ],
              //   colors: [
              //     Colors.pink[100]!,
              //     Colors.pink[100]!,
              //     Colors.pink[50]!,
              //     Colors.pink[50]!,
              //     Colors.pink[100]!,
              //     Colors.pink[100]!,
              //     Colors.pink[50]!,
              //     Colors.pink[50]!,
              //     Colors.pink[100]!,
              //     Colors.pink[100]!,
              //     Colors.pink[50]!,
              //     Colors.pink[50]!,
              //     Colors.pink[100]!,
              //     Colors.pink[100]!,
              //     Colors.pink[50]!,
              //     Colors.pink[50]!,
              //     Colors.pink[100]!,
              //     Colors.pink[100]!,
              //     Colors.pink[50]!,
              //     Colors.pink[50]!,
              //   ],
              //   tileMode: TileMode.repeated,
              // ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: TableCalendar(
                    locale: "en_US",
                    rowHeight: 45,
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    // calendarFormat: CalendarFormat.month,
                    // weekendDays: [],
                    focusedDay: today,
                    // eventLoader: (day){
                    //   return _estimatedNextPeriods.contains(day) ? [] : [];
                    // }
                    eventLoader: (day) {
                      print("day eta");
                      print(day);
                      print(_estimatedNextPeriods.contains(day));
                      print(_estimatedNextPeriods);
                      return _estimatedNextPeriods.contains(day)
                          ? ["next period"]
                          : [];
                    },
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 16),
                    onDaySelected: _onDaySelected,
                    // rangeStartDay: _rangeStart,
                    // rangeSelectionMode: RangeSelectionMode.toggledOn,
                    // onRangeSelected: _onRangeSelected,
                    // rangeEndDay: _rangeEnd,
                    calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        // unavailableTextStyle: TextStyle(
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold),
                        // weekendTextStyle: TextStyle(
                        //     color: Colors.pink[900],
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.w900),
                        // outsideTextStyle: TextStyle(
                        //     color: Colors.pink[900]
                        // ),
                        // outsideWeekendTextStyle: TextStyle(
                        //     color: Colors.pink[900]),
                        // weekdayTextStyle: TextStyle(
                        //     color: Colors.pink[900],
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.w900),

                        todayDecoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          shape: BoxShape.circle,
                        ),
                        // selectedColor: Theme.of(context).primaryColor,
                        todayTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white)
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,

                      // centerHeaderTitle: true,
                      titleTextStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: 22.0,
                          fontFamily: 'Poppins'),


                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    // onDaySelected: (date, events, ) {
                    //   print(date.toUtc());
                    // },
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // color: Theme.of(context).primaryColor,
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Poppins'),
                          )),
                      holidayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Poppins'),
                          )),
                    ),
                    // calendarController: _controller,
                    // focusedDay:_getStartDate() ?? DateTime.now(),
                  ),
                ),
                Divider(),
                Divider(),
                new Column(
                  children: [
                    Column(
                      children: [


                          Text("NEXT PERIOD: "),
                        SizedBox(height: 10,),
                        nextPeriod ==""?CircularProgressIndicator():Text(
                         nextPeriod, style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),),

                        // StreamBuilder(
                        //     stream: FirebaseFirestore.instance.collection('periodinfo').
                        //     snapshots(),
                        //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        //       if (snapshot.connectionState == ConnectionState.waiting) {
                        //         return Center(child: CircularProgressIndicator());
                        //       } else if(snapshot.hasError) {
                        //         return Center(child: Text('Error: ${snapshot.error}'));
                        //       } else {
                        //         return ListView.builder(
                        //           itemCount: snapshot.data.docs.length,
                        //             itemBuilder: (BuildContext context, int index) {
                        //             DocumentSnapshot document = snapshot.data() as Map<String, dynamic>;
                        //             }
                        //         );
                        //       }
                        //     }
                        // ),



                      ],
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      // width: 400,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(20)
                      ),


                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            child:  TextButton(

                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddPeriod()),
                                  );

                                },
                                child: Text(
                                  "ADD PERIOD",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                )),
                          ),
                          Icon(Icons.add, color: Colors.purple.shade400,),


                        ],
                      ),
                    ),
                    // Divider(),

                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      // width: 400,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(20)
                      ),


                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            child:  TextButton(
                              // style: ButtonStyle(
                              //   backgroundColor:
                              //   MaterialStateProperty.all<Color>(
                              //       Colors.purple.shade100),
                              // ),
                                onPressed: () {
                                  _displayTextInputDialog(
                                      context, "Temperature", "temperature");
                                },
                                child: Text(
                                  "TEMPERATURE",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                )),
                          ),
                          Icon(Icons.thermostat_outlined, color: Colors.purple.shade400,),


                          // SizedBox(
                          //     height: 60,
                          //     width: 360,
                          //     child: Padding(
                          //         padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          //         child: TextButton(
                          //             style: ButtonStyle(
                          //               backgroundColor:
                          //               MaterialStateProperty.all<Color>(
                          //                   Colors.purple.shade100),
                          //             ),
                          //             onPressed: () {
                          //               _displayTextInputDialog(
                          //                   context, "Temperature", "temperature");
                          //             },
                          //             child: Text(
                          //               "BODY TEMPERATURE",
                          //               style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontFamily: 'Poppins'),
                          //             ))
                          //     )),
                        ],
                      ),
                    ),
                    //

                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      // width: 400,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(20)
                      ),


                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            child:  TextButton(

                                onPressed: () {
                                  _displayTextInputDialog(
                                      context, "Mood", "mood");
                                },
                                child: Text(
                                  "MOOD",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                )),
                          ),
                          Icon(Icons.emoji_emotions_outlined, color: Colors.purple.shade400,),



                        ],
                      ),
                    ),
                    // Divider(),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      // width: 400,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(20)
                      ),



                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            child:  TextButton(
                              // style: ButtonStyle(
                              //   backgroundColor:
                              //   MaterialStateProperty.all<Color>(
                              //       Colors.purple.shade100),
                              // ),
                                onPressed: () {
                                  _displayTextInputDialog(
                                      context, "Weight", "weight");
                                },
                                child: Text(
                                  "WEIGHT",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                )),
                          ),
                          Icon(Icons.monitor_weight_outlined, color: Colors.purple.shade400,),


                          // SizedBox(
                          //     height: 60,
                          //     width: 360,
                          //     child: Padding(
                          //         padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          //         child: TextButton(
                          //             style: ButtonStyle(
                          //               backgroundColor:
                          //               MaterialStateProperty.all<Color>(
                          //                   Colors.purple.shade100),
                          //             ),
                          //             onPressed: () {
                          //               _displayTextInputDialog(
                          //                   context, "Temperature", "temperature");
                          //             },
                          //             child: Text(
                          //               "BODY TEMPERATURE",
                          //               style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontFamily: 'Poppins'),
                          //             ))
                          //     )),
                        ],
                      ),
                    ),
                    // Divider(),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      // width: 400,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(20)
                      ),



                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            child:  TextButton(

                                onPressed: () {
                                  _displayTextInputDialog(
                                      context, "Symptoms", "symptoms");
                                },
                                child: Text(
                                  "SYMPTOMS",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                )),
                          ),
                          Icon(Icons.sick_outlined, color: Colors.purple.shade400,),


                          // SizedBox(
                          //     height: 60,
                          //     width: 360,
                          //     child: Padding(
                          //         padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          //         child: TextButton(
                          //             style: ButtonStyle(
                          //               backgroundColor:
                          //               MaterialStateProperty.all<Color>(
                          //                   Colors.purple.shade100),
                          //             ),
                          //             onPressed: () {
                          //               _displayTextInputDialog(
                          //                   context, "Temperature", "temperature");
                          //             },
                          //             child: Text(
                          //               "BODY TEMPERATURE",
                          //               style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontFamily: 'Poppins'),
                          //             ))
                          //     )),
                        ],
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.purple.shade50,
            selectedItemColor: Colors.purple.shade200,
            unselectedItemColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.escalator_warning),
                  label: "Community"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_outlined), label: "Analytics"),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _pageIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              _OnTap();
            },
            elevation: 5),
        drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.purple.shade100, //This will change the drawer background to blue.
              //other styles
            ),
            child: Drawer(
              child: ListView(
                children: [
                  // DrawerHeader(
                  //   padding: const EdgeInsets.fromLTRB(0, 2, 20, 2),
                  //   decoration: BoxDecoration(
                  //     color: Colors.purple.shade100,
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       IconButton(
                  //           iconSize: 100,
                  //           padding: EdgeInsets.fromLTRB(0.1, 2, 2, 2),
                  //           icon: Image.asset('assets/logo.png'),
                  //           onPressed: () => {}),
                  //       Text(
                  //         "My Cycles",
                  //         style: TextStyle(
                  //             fontFamily: 'Allura',
                  //             fontSize: 40,
                  //             color: Colors.purple.shade50),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.purple.shade100
                    ),
                    child: ListTile(
                      // tileColor: Colors.purple.shade100,
                      trailing: Icon(
                        Icons.note_alt_outlined,
                        color: Colors.purple.shade400,
                        size: 40,
                      ),
                      title: Text(
                        "Health Tips",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins'),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HealthTips()));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.purple.shade100
                    ),
                    child: ListTile(
                      // tileColor: Colors.purple.shade100,
                      trailing: Icon(
                        Icons.medical_information_outlined,
                        color: Colors.purple.shade400,
                        size: 40,
                      ),
                      title: Text(
                        "Medicine",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins'),
                      ),
                      onTap: () {
                        _displayTextInputDialog(context, "Medicine", "medicine");
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.purple.shade100
                    ),
                    child: ListTile(
                      // tileColor: Colors.purple.shade100,
                      trailing: Icon(
                        Icons.chat_outlined,
                        color: Colors.purple.shade400,
                        size: 40,
                      ),
                      title: Text(
                        "My Logs",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins'),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Logs()));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.purple.shade100,

                    ),
                    child: ListTile(
                      trailing: Icon(
                        Icons.feedback_outlined,
                        color: Colors.purple.shade400,
                        size: 40,
                      ),
                      title: Text(
                        "Feedback",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FeedbackForm()),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: 20,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.purple.shade100,

                    ),
                    // child: TextButton(
                    //   onPressed: () {
                    //     Navigator.push(context, CupertinoPageRoute(
                    //         builder: (context) => LogIn()
                    //     ));
                    //   }, child: Text("Log Out"),
                    //
                    // )
                    child: IconButton(
                      onPressed: () {
                        logOut();
                      }, icon: Icon(Icons.exit_to_app_outlined),
                    ),
                  ),
                  // SizedBox(
                  //   height: 190,
                  // ),
                  Container(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          leading: Icon(
                            Icons.arrow_back,
                            color: Colors.purple.shade400,
                            size: 40,
                          ),
                          title: Text(
                            "Back",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.right,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ))
                ],
              ),
            ))
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  late String codeDialog;
  late String valueText;
  _displayTextInputDialog(
      BuildContext context, String heading, String collection_name) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(heading),
            backgroundColor: Colors.purple.shade50,
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter your " + heading),
            ),
            actions: <Widget>[
              TextButton(
                // style: ButtonStyle(
                //   backgroundColor:
                //       MaterialStateProperty.all<Color>(Colors.purple.shade50),
                // ),
                child: Text(
                  'CANCEL',
                  style:
                  TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.purple.shade200),
                ),
                child: Text('SUBMIT',
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'Poppins')),
                onPressed: () {
                  DateTime now = new DateTime.now();
                  String dateValue = formatter.format(now);

                  String? user = FirebaseAuth.instance.currentUser?.email;

                  FirebaseFirestore.instance.collection(collection_name).add({
                    "Value": valueText,
                    "Date": dateValue,
                    "user": user
                  }).then((value) {
                    print(value.id);
                  }).catchError((error) => print("Failed to add data: $error"));
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
