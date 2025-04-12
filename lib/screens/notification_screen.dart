import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
   const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
   List<String> names = ['Alice', 'Bob', 'Charlie'];



  @override
  Widget build(BuildContext context) {
    List<Widget> nameWidgets = names.map((name) {
      return Column(
        children: [
          NotificationCard(),
          SizedBox(height: 6,)
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 35),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text("Notifications"),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("New"),
              SizedBox(height: 10,),
              Column(
                children: nameWidgets,
              ),
              Text("Previous Notification"),
              SizedBox(height: 10,),
              NotificationCard(),
              SizedBox(height: 5,),
              NotificationCard()
            ],
          )
        ],
      ),
    );
  }
}


class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber,
            color: Colors.red,
            size: 45,
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Text(
              "The water in pond A has exceeded threshold,\n Current Temperature: 41 C",
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
