import 'dart:convert';
import 'package:coronalocflutterapp/stat_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(MyApp());
}

int confirmed = 0, deaths = 0, recovered = 0, active = 0;
String countryName = 'Enter a Country!', date;

int day = DateTime.now().day,
    month = DateTime.now().month,
    year = DateTime.now().year;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
            primaryColor: Color(0xff0A0E21),
            scaffoldBackgroundColor: Color(0xff0A0E21)),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff0A0E21),
            title: Text('Corona Virus Statistics '),
          ),
          body: Builder(
            builder: (context) => SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  StatContainer(
                    statText: 'Country: $countryName',
                    statIcon: FaIcon(FontAwesomeIcons.flag),
                  ),
                  StatContainer(
                    statText: 'Confirmed Cases: $confirmed ',
                    statIcon: FaIcon(FontAwesomeIcons.checkCircle),
                  ),
                  StatContainer(
                    statText: 'Deaths: $deaths',
                    statIcon: FaIcon(FontAwesomeIcons.skullCrossbones),
                  ),
                  StatContainer(
                    statText: 'Recovered Patients: $recovered',
                    statIcon: FaIcon(FontAwesomeIcons.medkit),
                  ),
                  StatContainer(
                    statText: 'Active Cases: $active',
                    statIcon: FaIcon(FontAwesomeIcons.exclamationCircle),
                  ),
                  StatContainer(
                    statText: 'Date of This Data: $day.$month.$year',
                    statIcon: FaIcon(FontAwesomeIcons.calendarDay),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            onChanged: (countryValue) {
                              countryName = countryValue;
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Your Country",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.elliptical(10, 25),
                                bottom: Radius.elliptical(10, 25))),
                        child: Text(
                          'Show Corona Statistics',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        color: Color(0xffeb1555),
                        padding: EdgeInsets.all(8),
                        onPressed: () async {
                          Response response = await get('$apiLink$countryName');
                          print(response.statusCode);
                          DateTime today = DateTime.now();
                          int difference = today.difference(dateStart).inDays;
                          print(difference);
                          setState(() {
                            if (response.statusCode != 200) {
                              Alert(
                                      style: AlertStyle(
                                        animationType: AnimationType.fromTop,
                                        descStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        titleStyle: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      type: AlertType.error,
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            'Okay',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          color: Colors.red,
                                        )
                                      ],
                                      context: context,
                                      title: "Oops!",
                                      desc:
                                          "Could not reach the data. Try again later!")
                                  .show();
                            }
                            confirmed =
                                jsonDecode(response.body)[difference - 2]
                                    ['Confirmed'];

                            deaths = jsonDecode(response.body)[difference - 2]
                                ['Deaths'];
                            recovered =
                                jsonDecode(response.body)[difference - 2]
                                    ['Recovered'];
                            active = jsonDecode(response.body)[difference - 2]
                                ['Active'];
                            date = jsonDecode(response.body)[difference - 2]
                                ['Date'];
                            day = DateTime.parse(date).day;
                            month = DateTime.parse(date).month;
                            year = DateTime.parse(date).year;
                          });
                        },
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        'Statistics about corona in every country. ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w100),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
