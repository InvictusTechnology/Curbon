class Trips {
  String destination;
  String starting;
  String transport;
  String distance;
  String carbon; // will be in (kg of CO2/passenger-kilometre)
  String user;
  int date;

  Trips(
      {this.destination,
      this.starting,
      this.distance,
      this.carbon,
      this.transport,
      this.user,
      this.date});
}
