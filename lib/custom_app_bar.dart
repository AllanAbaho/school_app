import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData icon;
  const CustomAppBar(this.title, this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Icon(icon),
        ),
      ],
    );
  }
}

class MediumText extends StatelessWidget {
  const MediumText(
    this.text, {
    this.color = Colors.black,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12),
    );
  }
}

Widget buildDescription(String title,
    {String description =
        'Choose our list of customised categories and avail the services in each.'}) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            height: 2,
            fontWeight: FontWeight.w300),
      ),
      Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 8.0, bottom: 20, right: 8.0),
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w300),
        ),
      ),
    ],
  );
}

showToast(BuildContext context, String text) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      // action: SnackBarAction(
      //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}
