import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatContainer extends StatelessWidget {
  StatContainer({this.statText, this.statIcon});
  final String statText;
  final FaIcon statIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      constraints: BoxConstraints.tightFor(height: 50, width: double.infinity),
      color: Color(0xFF1D1E33),
      child: ListTile(
        title: Text(
          '$statText',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: statIcon,
      ),
    );
  }
}
