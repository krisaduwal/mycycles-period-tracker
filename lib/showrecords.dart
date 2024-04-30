
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShowRecord extends StatelessWidget {
  final List argument;
  final String title;
  const ShowRecord({required this.argument,required this.title});

  @override
  Widget build(BuildContext context) {
    argument.forEach((doc) {
      print(doc.data());
    });
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
        title: Text(this.title,
          style: TextStyle(fontFamily: 'Allura', fontSize: 30),),
        backgroundColor: Colors.purple.shade100,
        centerTitle: true,
        elevation: 5.0,

      ),
      body: Column(
        children: [
          Image(
              image: AssetImage('assets/records.png'),
              width:200 ,fit: BoxFit.cover),
          Expanded(
            child: ListView.builder(
              itemCount: argument.length,

              itemBuilder: (context, index) {
                dynamic data = argument[index].data();
                return Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        padding: EdgeInsets.all(15),
                        // width: 400,=
                        decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text("Date:"),
                                SizedBox(width: 10,),//lau kata gayopadding le khayo
                                Text("${data["Date"]}"),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 50,),
                                Text(this.title),
                                Text(":"),
                                SizedBox(width: 10,),
                                Text("${data["Value"]}")
                              ],
                            ),

                          ],

                        ),
                      )
            
                    ],
                  ),
                );
            },),
          ),
        ],
      ),
    );
  }
}
