
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contactus/contactus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_cycles/aboutus.dart';
import 'package:my_cycles/home_screen.dart';
import 'package:my_cycles/community.dart';
import 'package:my_cycles/main.dart';
import 'package:my_cycles/showrecords.dart';
import 'myinfo.dart';

var valueArray = [];
var dateArray = [];
Map<String, dynamic> map = {};
String value = '';
String date = '';

const magenta = const Color(0x8e3a59);
void main() async {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: MyCycles()),
  );
}

class Logs extends StatefulWidget {
  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  // ignore: non_constant_identifier_names

  @override
  void initState() {
    super.initState();
    print("log started");
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
          "My Logs",
          style: TextStyle(fontFamily: 'Allura', fontSize: 30, ),
        ),
        backgroundColor: Colors.purple.shade100,
        centerTitle: true,
        elevation: 5.0,
      ),
      body: SingleChildScrollView(
        child: new Container(
          height: MediaQuery.of(context).size.height,

          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                    image: AssetImage('assets/mylog.png'), fit: BoxFit.cover),
                Divider(),
                Text("My Records: ",
                    style: TextStyle(
                      color: Colors.purple.shade400,
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 2,fontFamily: 'Poppins'
                    ),
                    textAlign: TextAlign.center),
                Divider(),
                // Material(
                //   child: ListTile(
                //       tileColor: Colors.purple.shade100,
                //       title: Text("Temperature Records",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.bold,
                //               letterSpacing: 3, fontFamily: 'Poppins')),
                //       trailing: IconButton(
                //         icon: Icon(Icons.navigate_next),
                //         onPressed: () => Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => MyInfo(
                //                 text: 'temperature', key: ValueKey('myUniqueKey'),
                //               ),
                //             )),
                //       )),
                // ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple.shade100)),
                    onPressed: () {
                      print("on pressed");
                      String? user = FirebaseAuth.instance.currentUser?.email;
                      FirebaseFirestore.instance
                          .collection('temperature')
                          .where("user",isEqualTo:user)
                          .get()
                          .then((querySnapshot) {
                          Navigator.push(context, MaterialPageRoute(builder:(context) => ShowRecord(argument:querySnapshot.docs as List,title:"Temperature"),));
                        querySnapshot.docs.forEach((result) {
                          print(result.data());
                          map = result.data();
                          value = map['Value'];
                          // valueArray.add(value);
                          // print(valueArray);
                          // date = map['Date'];
                          // dateArray.add(date);
                          // print(dateArray);
                        });
                      });
                    },
                    child: Text('Temperature records',
                        style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'Poppins'))),
                Divider(),
                // Material(
                //   child: ListTile(
                //       tileColor: Colors.purple.shade100,
                //       title: Text(
                //         "Mood Records",
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontWeight: FontWeight.bold,
                //             letterSpacing: 3, fontFamily: 'Poppins'),
                //       ),
                //       trailing: IconButton(
                //         icon: Icon(Icons.navigate_next),
                //         onPressed: () => Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => MyInfo(
                //                 text: 'mood', key: ValueKey('myUniqueKey'),
                //               ),
                //             )),
                //       )),
                // ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple.shade100)),
                    onPressed: () {
                      String? user = FirebaseAuth.instance.currentUser?.email;
                      FirebaseFirestore.instance
                          .collection('mood')
                          .where("user",isEqualTo:user)
                          .get()
                          .then((querySnapshot) {
                        Navigator.push(context, MaterialPageRoute(builder:(context) => ShowRecord(argument:querySnapshot.docs as List,title:"Mood"),));
                        querySnapshot.docs.forEach((result) {
                          print(result.data());
                          map = result.data();
                          value = map['Value'];
                          // valueArray.add(value);
                          // print(valueArray);
                          // date = map['Date'];
                          // dateArray.add(date);
                          // print(dateArray);
                        });
                      });
                    },
                    child: Text('Mood Records',
                        style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'Poppins'))),
                Divider(),
                // Material(
                //   child: ListTile(
                //       tileColor: Colors.purple.shade100,
                //       title: Text("Weight Records",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.bold,
                //               letterSpacing: 3, fontFamily: 'Poppins')),
                //       trailing: IconButton(
                //         icon: Icon(Icons.navigate_next),
                //         onPressed: () => Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => MyInfo(
                //                 text: 'weight', key: ValueKey('myUniqueKey'),
                //               ),
                //             )),
                //       )),
                // ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple.shade100)),
                    onPressed: () {
                      String? user = FirebaseAuth.instance.currentUser?.email;
                      FirebaseFirestore.instance
                          .collection('weight')
                          .where("user",isEqualTo:user)
                          .get()
                          .then((querySnapshot) {
                        Navigator.push(context, MaterialPageRoute(builder:(context) => ShowRecord(argument:querySnapshot.docs as List,title:"Weight"),));
                        querySnapshot.docs.forEach((result) {
                          print(result.data());
                          map = result.data();
                          value = map['Value'];
                          // valueArray.add(value);
                          // print(valueArray);
                          // date = map['Date'];
                          // dateArray.add(date);
                          // print(dateArray);
                        });
                      });
                    },
                    child: Text('Weight Records',
                        style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'Poppins'))),
                Divider(),
                // Material(
                //   child: ListTile(
                //       tileColor: Colors.purple.shade100,
                //       title: Text("Medicine Records",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.bold,
                //               letterSpacing: 3, fontFamily: 'Poppins')),
                //       trailing: IconButton(
                //         icon: Icon(Icons.navigate_next),
                //         onPressed: () => Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => MyInfo(
                //                 text: 'medicine', key: ValueKey('myUniqueKey'),
                //               ),
                //             )),
                //       )),
                // ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple.shade100)),
                    onPressed: () {
                      String? user = FirebaseAuth.instance.currentUser?.email;
                      FirebaseFirestore.instance
                          .collection('medicine')
                          .where("user",isEqualTo:user)
                          .get()
                          .then((querySnapshot) {
                        Navigator.push(context, MaterialPageRoute(builder:(context) => ShowRecord(argument:querySnapshot.docs as List,title:"Medicine"),));
                        querySnapshot.docs.forEach((result) {
                          print(result.data());
                          map = result.data();
                          value = map['Value'];
                          // valueArray.add(value);
                          // print(valueArray);
                          // date = map['Date'];
                          // dateArray.add(date);
                          // print(dateArray);
                        });
                      });
                    },
                    child: Text('Medicine Records',
                        style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'Poppins'))),
                Divider(),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple.shade100)),
                    onPressed: () {
                      String? user = FirebaseAuth.instance.currentUser?.email;
                      FirebaseFirestore.instance
                          .collection('symptoms')
                          .where("user",isEqualTo:user)
                          .get()
                          .then((querySnapshot) {
                        Navigator.push(context, MaterialPageRoute(builder:(context) => ShowRecord(argument:querySnapshot.docs as List,title:"Symptom:"),));
                        querySnapshot.docs.forEach((result) {
                          print(result.data());
                          map = result.data();
                          value = map['Value'];
                          // valueArray.add(value);
                          // print(valueArray);
                          // date = map['Date'];
                          // dateArray.add(date);
                          // print(dateArray);
                        });
                      });
                    },
                    child: Text('Symptom Records',
                        style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'Poppins'))),
                // Material(
                //   child: ListTile(
                //       tileColor: Colors.purple.shade100,
                //       title: Text("Symptoms",
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.bold,
                //               letterSpacing: 3, fontFamily: 'Poppins')),
                //       trailing: IconButton(
                //         icon: Icon(Icons.navigate_next),
                //         onPressed: () => Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => MyInfo(
                //                 text: 'symptoms', key: ValueKey('myUniqueKey'),
                //               ),
                //             )),
                //       )),
                // )
              ]),
        ),
      ),
    );

    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
