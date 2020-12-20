import 'package:amcham_app_v2/components/event_item.dart';
import 'package:amcham_app_v2/components/rounded_button.dart';
import 'package:amcham_app_v2/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amcham_app_v2/components/get_firebase_image.dart';
import 'events_screen.dart';
import 'event_register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SingleEventScreen extends StatefulWidget {
  String testStr = '';
  final EventItem item;
  String DateToString(int numberDate) {
    String strNumberDate = numberDate.toString();
    String year = strNumberDate.substring(0, 4);
    String month = strNumberDate.substring(4, 6);
    int monthInt = int.parse(month);
    List<String> dates = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    month = dates[monthInt - 1];

    String day = strNumberDate.substring(6, 8);
    return '$day $month $year';
  }

  SingleEventScreen({@required this.item});
  @override
  _SingleEventScreenState createState() => _SingleEventScreenState(item: item);
}

class _SingleEventScreenState extends State<SingleEventScreen> {
  BoxDecoration activeDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(width: 2, color: Colors.lightBlue.shade900),
    ),
  );
  BoxDecoration inActiveDecoration = BoxDecoration();

  bool isInfoActive = true;

  final EventItem item;
  @override
  void initState() {
    BoxDecoration activeDecoration = BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 2, color: Colors.lightBlue.shade900),
      ),
    );
    BoxDecoration inActiveDecoration = BoxDecoration();
    item.isButton = false;
    item.showInfo = true;
    item.hideSummary = true;
    item.infoButtonFunction = () {
      setState(() {
        print('test');
        item.isInfoSelected = true;
      });
    };
    item.speakersButtonFunction = () {
      print('test');
      setState(() {
        item.isInfoSelected = false;
      });
    };

    super.initState();
  }

  String userEmail = FirebaseAuth.instance.currentUser.email;
  bool checkOwnedEvent() {
    List<dynamic> users = item.registeredUsers;

    for (var user in users) {
      if (user.toString() == userEmail) {
        print('event is already owned');
        return true;
      }
    }
    return false;
  }

  _SingleEventScreenState({@required this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.blueThemeColor,
      ),
      body: Stack(
        children: [
          Container(
            child: ListView(
              children: [
                item,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            isInfoActive = true;
                          });
                        },
                        child: Container(
                          child: Text('Info'),
                          decoration: isInfoActive
                              ? activeDecoration
                              : inActiveDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            isInfoActive = false;
                          });
                        },
                        child: Container(
                          child: Text('Speakers'),
                          decoration: isInfoActive
                              ? inActiveDecoration
                              : activeDecoration,
                        ),
                      ),
                    ],
                  ),
                ),
                isInfoActive
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(item.info),
                      )
                    : Container(
                        //TODO add speaker functionality
                        ),
              ],
            ),
          ),
          Align(
            //TODO validate whether user has pruchased this item and then write 'owned'
            alignment: Alignment.bottomCenter,
            child: RoundedButton(
              title: checkOwnedEvent()
                  ? 'Registered'
                  : item.price == 0
                      ? 'Register: FREE'
                      : 'Register: R${item.price}',
              onPressed: () {
                Navigator.push(
                  //push with price and event ID
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventRegisterScreen(
                      id: item.id,
                      eventItem: item,
                      isEventAlreadyOwned: checkOwnedEvent(),
                    ),
                  ),
                );
              },
              radius: 10,
              width: 350,
              colour: Constants.blueThemeColor,
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}