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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(color: Colors.white),),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(notification: notification);
          },
        ),
      )
          : const Center(child: Text("Notification feed is empty")),
    );
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
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
                size: 45,
              ),
              SizedBox(width: 15,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['title'],
                      softWrap: true,
                    ),
                    Text(
                      notification['message'],
                      softWrap: true,
                    ),
                    Text(
                      DateTime.parse(notification['created_at']).toLocal().toString(),
                      softWrap: true,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
