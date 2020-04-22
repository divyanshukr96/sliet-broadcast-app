import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sliet_broadcast/core/models/message.dart';
import 'package:sliet_broadcast/utils/device_registration.dart';

class FireBaseNotification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<FireBaseNotification> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  final List<Message> messages = [];

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      return null;
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    return null;
    // Or do other work.
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if ((message['notification'] != null) &&
            (message['notification'].length > 0)) {
          _showItemDialog(message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('on Resume: $message');
        final notification = message['notification'];
        if (notification.length == 0) return;
      },
//      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('on Launch: $message');
        final notification = message['notification'];
      },
    );
    DeviceRegistration.register(fireBaseMessaging: _firebaseMessaging);
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: messages.map(buildMessage).toList(),
    );
  }

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );

  void _showItemDialog(notification) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, notification['notification']),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
//        _navigateToItemDetail(message);
      }
    });
  }

  Widget _buildDialog(BuildContext context, message) {
    print(message);
    return AlertDialog(
      title: Text('New notice from ${message['title']}'),
      content: Text(" ${message['body']}"),
      actions: <Widget>[
        FlatButton(
          child: Text("CLOSE"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
