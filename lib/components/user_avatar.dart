import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String userId;

  const UserAvatar({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      child: Text(userId.substring(0, 3)),
    );
  }
}