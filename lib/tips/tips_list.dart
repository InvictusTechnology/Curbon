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
    TipsConstructor(
        title: 'Ever heard of rideshare?',
        content:
            'It saves money, of course. It also saves your carbon emission! The calculation would simply divide the typical emission of a car by the passengers'),
    TipsConstructor(
        title: 'Drive carefully!',
        content:
            'It\'s better to be safe than sorry! Aggressive driving, those including unnecessary braking and acceleration can result 40% more fuel consumption'),
    TipsConstructor(
        title: 'Take care of your car',
        content:
            'Study shows that by taking care of your tires, it would increase fuel efficiency for 3%'),
    TipsConstructor(
        title: 'Cruise control',
        content:
            'While on a longer trip, try to maximise the use of cruise control, it increases gas efficiency'),
    TipsConstructor(
        title: 'Public transport at all times',
        content:
            'The use of public transports (bus, tram, train, etc.) aim to maximise the use of a single mode of transport to save its carbon emissions. '),
    TipsConstructor(
        title: 'Be a smart buyer',
        content:
            'When you are about to purchase a new car, don\'t be shy to ask for its fuel efficiency. It all depends on the how you can save your fuel efficiency'),
    TipsConstructor(
        title: 'Get a mounted-rack',
        content:
            'Avoid roof-top boxes on your vehicle. It costs more, increase aerodynamic drag, and decrease fuel efficiency. Always go for a mounted-rack when in need of extra spaces'),
    TipsConstructor(
        title: 'Fine tune your vehicle',
        content:
            'Using the correct grade of motor oil and to keep your engine tuned, can increase fuel efficiency by up to 40%'),
    TipsConstructor(
        title: 'Combine your errands',
        content:
            'If you need to make multiple trips, it would be better to combine them in one go. You would be surprise how much it will save you'),
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
