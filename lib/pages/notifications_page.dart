import 'package:flutter/material.dart';
import 'package:musicsocial/widgets/notification.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          centerTitle: true,
        ),
        body: ListView.separated(
          itemCount: 15,
          key: PageStorageKey(this.key),
          separatorBuilder: (context, index) {
            return Divider(
              height: 0.0,
            );
          },
          itemBuilder: (context, index) {
            return Container(
                child: new NotificationWidget(
              // TODO get notification from DB
              username: "@username$index",
              notification: (index % 3 == 1)
                  ? "liked your post."
                  : "started following you.",
              timestamp: "${index * 3 + 1}m",
              isPost: (index % 3 == 1) ? true : false,
              post: null,
            ));
          },
        ));
  }
}
