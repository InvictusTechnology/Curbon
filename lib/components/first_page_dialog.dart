import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomDialog extends StatelessWidget {
  final primaryColor = const Color(0xFF26CB7E);
  final grayColor = const Color(0xFF939393);

  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute,
      secondaryButtonText,
      secondaryButtonRoute;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.primaryButtonText,
    @required this.primaryButtonRoute,
    this.secondaryButtonText,
    this.secondaryButtonRoute,
  });

  static const double padding = 15.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [BoxShadow(color: Colors.grey[700])],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 24.0),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24.0),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grayColor,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 24.0),
                RaisedButton(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: AutoSizeText(
                      primaryButtonText,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(primaryButtonRoute);
                  },
                ),
                SizedBox(height: 5.0),
                showSecondaryButton(context),
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/loading');
                    },
                    child: Text(
                      'Not Now',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  showSecondaryButton(BuildContext context) {
    if (secondaryButtonRoute != null && secondaryButtonText != null) {
      return FlatButton(
        child: AutoSizeText(
          secondaryButtonText,
          maxLines: 1,
          style: TextStyle(
            fontSize: 19,
            color: primaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(secondaryButtonRoute);
        },
      );
    } else {
      return SizedBox(height: 10.0);
    }
  }
}
