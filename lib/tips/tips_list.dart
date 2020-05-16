import 'package:curbonapp/tips/tips_constructor.dart';

class TipsList {
  List<TipsConstructor> _tipsBank = [
    TipsConstructor(
        title: 'Tram has biggest emission?',
        content:
            'According to Ed Boyapati (2003), Tram emits more than other vehicles. But, with more passengers to carry, it can save more!'),
    TipsConstructor(
        title: 'Bus has the-what?',
        content:
            'Bus, surprisingly, has the lowest carbon emission than other vehicles!'),
    TipsConstructor(
        title: 'Burn those extras!',
        content:
            ' According to Harvard University, cycling at a speed of between 12 to 13.9 miles/hour can burn 298 calories in 30 mins'),
    TipsConstructor(
        title: 'Extra speed, extra burn',
        content:
            'According to Harvard University, cycling at a faster rate between 14 to 15.9 miles/hour can burn 372 calories in 30 mins'),
    TipsConstructor(
        title: 'Keep this up!',
        content:
            'By keeping in track all your trips and understand them, you\'re helping us to understand human behaviour in fighting the carbon emissions'),
  ];

  int getTotalList() {
    return _tipsBank.length;
  }

  String getContent(int i) {
    return _tipsBank[i].content;
  }

  String getTitle(int i) {
    return _tipsBank[i].title;
  }
}
