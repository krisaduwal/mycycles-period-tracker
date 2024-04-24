import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class nextPeriod extends StatefulWidget {
  // const nextPeriod({super.key});

  @override
  State<nextPeriod> createState() => _nextPeriodState();
}

class _nextPeriodState extends State<nextPeriod> {
  @override

  getDataFromDatabase() async {
    var value = FirebaseFirestore.instance.collection('periodinfo');
    var getValue = await value.doc('periodinfo').get();

  }

  Widget build(BuildContext context) {
    // TODO: implement build
    // return FutureBuilder(
    //     future: getDataFromDatabase(),
    //     builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //       if (snapshot.hasData) {
    //         var showData = snapshot.data;
    //         Map<dynamic, dynamic> values = showData.value;
    //         List<dynamic> key = values.keys.toList();
    //
    //         for(int i = 0; i < key.length; i++) {
    //           final data = values[key[i]];
    //
    //         }
    //       }
    //     });
    return Scaffold(
      appBar: AppBar(
        title: Text('blabla'),
      ),
    );
  }
}
