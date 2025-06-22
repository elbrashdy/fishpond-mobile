import 'package:fishpond/providers/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
   const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List notifications = [];
  bool isLoading = true;

  getNotification() async {
    await Provider
        .of<NotificationProvider>(context, listen: false)
        .getNotification();
    setState(() {
      notifications = Provider
          .of<NotificationProvider>(context, listen: false)
          .getNotifications;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifications.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(notification: notification,); // Pass data to card
          },
        ),
      );
    } else {
      return const Center(child: Text("Notification feed is empty"));
    }
  }
}


class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  const NotificationCard({super.key, required this.notification});

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
              '',
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
