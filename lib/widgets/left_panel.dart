import 'package:flutter/material.dart';
import 'package:pinkvilla_demo/theme/colors.dart';


class LeftPanel extends StatelessWidget {
  final String name;
  final String caption;
  const LeftPanel({
    Key key,
    @required this.size,
    this.name,
    this.caption,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
                color: white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            caption,
            style: TextStyle(color: white),
          ),
          SizedBox(
            height: 5,
          ),
         
        ],
      ),
    );
  }
}