
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_cycles/main.dart';
import 'package:my_cycles/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: MyCycles()),
  );
}

class AddPeriod extends StatefulWidget {
  @override
  _AddPeriodState createState() => _AddPeriodState();
}

class _AddPeriodState extends State<AddPeriod> {
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
          "My Period",
          style: TextStyle(fontFamily: 'Allura', fontSize: 30, ),
        ),
        backgroundColor: Colors.purple.shade100,
        centerTitle: true,
        elevation: 5.0,
      ),
      body: SingleChildScrollView(
          child: new Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

              child: Container(
                  child: Form(
                child: FormUI(),
              )))),
    );
  }
}

class FormUI extends StatefulWidget {
  @override
  _FormUIState createState() => _FormUIState();
}

class _FormUIState extends State<FormUI> {
  TextEditingController _textFieldController = TextEditingController();
  DateTime currentDate = DateTime.now();
  DateTime startDate = DateTime(2021, 12, 1);
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  int duration = 0;
  late int temp;
  int cycleLength = 0;
  int flow = 0;

  _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.purple.shade100,
                onPrimary: Colors.purple.shade200,
                surface: Colors.purple.shade50,
                onSurface: Colors.purple.shade300,
              ),
              dialogBackgroundColor: Colors.purple.shade50,
            ),
            child: child!,
        );
      }
      // Theme(
      //     data: ThemeData.dark().copyWith(
      //       colorScheme: ColorScheme.dark(
      //         primary: Colors.pink[900],
      //         onPrimary: Colors.pink[100],
      //         surface: Colors.pink[100],
      //         onSurface: Colors.pink[900],
      //       ),
      //       dialogBackgroundColor: Colors.pink[100],
      //     ),
      //
      //
      // ),
      // builder: (BuildContext context, Widget child) {
      //   return Theme(
      //     data: ThemeData.dark().copyWith(
      //       colorScheme: ColorScheme.dark(
      //         primary: Colors.pink[900],
      //         onPrimary: Colors.pink[100],
      //         surface: Colors.pink[100],
      //         onSurface: Colors.pink[900],
      //       ),
      //       dialogBackgroundColor: Colors.pink[100],
      //     ),
      //     child: child,
      //   );
      // },
    );
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        startDate = pickedDate;
      });
  }

  _displayTextInputDialog(BuildContext context, String heading) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(heading),
            backgroundColor: Colors.purple.shade50,
            content: TextField(
              onChanged: (value) {
                setState(() {
                  temp = int.parse(value);
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter your " + heading),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purple.shade200),
                ),
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
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
                      MaterialStateProperty.all<Color>(Colors.purple.shade100),
                ),
                child: Text('OK', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
                onPressed: () {
                  setState(() {
                    if (heading == 'Duration') {
                      duration = temp;
                    } else if (heading == 'Cycle Length') {
                      cycleLength = temp;
                    } else if (heading == 'Flow') {
                      flow = temp;
                    } else {
                      print('Invalid request.');
                    }
                    temp = 0;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  _sendData() async {
    DateTime endDate = startDate.add(Duration(days: duration));
    DateTime nextDate = startDate.add(Duration(days: cycleLength));
    final dbInstance = FirebaseFirestore.instance;
    String? user = FirebaseAuth.instance.currentUser?.email;
    print(user);
    QuerySnapshot querySnapshot = await dbInstance.collection('periodinfo').where("user",isEqualTo: user).get();
    if(querySnapshot.docs.length >=1)
      {
        final id = querySnapshot.docs[0].id;
        await dbInstance.collection('periodinfo').doc(id).delete();
      }
    dbInstance.collection('periodinfo').add({
      "Cycle Length": cycleLength,
      "Duration": duration,
      "Flow": flow,
      "user":user,
      "Selected Date": {
        "start": formatter.format(startDate),
        "end": formatter.format(endDate),
        "next": formatter.format(nextDate),
      }
    }).then((value) {
      print(value.id);
      final snackBar = SnackBar(
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text('Your Period Info was addded!',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins')),
        backgroundColor: Colors.purple.shade300,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)=>MyCycles()),
      (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      final snackBar = SnackBar(
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text('Error in submitting!',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.pink[50], fontFamily: 'Poppins')),
        backgroundColor: Colors.purple.shade100,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Material(

            child: ListTile(

          title: Text('Period Start',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          subtitle: Text(formatter.format(startDate),
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          tileColor: Colors.purple.shade100?.withOpacity(0.7),
          trailing: IconButton(
            onPressed: () {
              _selectDate(context);
            },
            icon: Icon(
              Icons.calendar_view_day_rounded,
              color: Colors.purple.shade400,
              size: 40,
            ),
          ),
        )),
        Material(
            child: ListTile(
          title: Text('Duration',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          subtitle: Text(duration.toString(),
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          tileColor: Colors.purple.shade100?.withOpacity(0.7),
          trailing: IconButton(
            onPressed: () {
              _displayTextInputDialog(context, 'Duration');
            },
            icon: Icon(
              Icons.calendar_view_month,
              color: Colors.purple.shade400,
              size: 40,
            ),
          ),
        )),
        Material(
            child: ListTile(
          title: Text('Cycle Length',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          subtitle: Text(cycleLength.toString(),
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          tileColor: Colors.purple.shade100?.withOpacity(0.7),
          trailing: IconButton(
            onPressed: () {
              _displayTextInputDialog(context, 'Cycle Length');
            },
            icon: Icon(
              Icons.circle_outlined,
              color: Colors.purple.shade400,
              size: 40,
            ),
          ),
        )),
        Material(
            child: ListTile(
          title: Text('Flow',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          subtitle: Text(flow.toString(),
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          tileColor: Colors.purple.shade100?.withOpacity(0.7),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 200,
                  child: SliderTheme(
                      data: SliderThemeData(
                          thumbColor: Colors.purple.shade200,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 10)),
                      child: Slider(
                        value: flow.toDouble(),
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: flow.round().toString(),
                        activeColor: Colors.purple.shade200,
                        inactiveColor: Colors.purple.shade50,
                        onChanged: (double value) {
                          setState(() {
                            flow = value.round().toInt();
                          });
                        },
                      ))),
              IconButton(
                onPressed: () {
                  _displayTextInputDialog(context, 'Flow');
                },
                icon: Icon(
                  Icons.water_drop,
                  color: Colors.purple.shade400,
                  size: 40,
                ),
              ),
            ],
          ),
        )),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purple.shade100),
                ),
                onPressed: () {
                  _sendData();
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal, fontFamily: 'Poppins'),
                ))),
      ],
    );
  }
}
