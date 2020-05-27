# Curbon 
An application created by Invictus Technology, Monash University. This app is aimed to help students to be aware of carbon emissions. We are aiming for a net-zero carbon emission. Curbon helps students to track, monitor, and learn from their previous trips, how much they are emitting. It will provide tips along the way for students to reduce their carbon emission

## Getting started
To get started, you may need Android Studio (or Visual Studio Code) to be able to run flutter and dart
Then, you can simply clone this project and run it to an android emulator (or even better, iPhone)
The project was created and designed to target broader audience in term of platform (Android and iOS)
During development, the emulators that we mostly used to test the functionalities were Google Pixel 3a XL, iPhone 11 and iPhone X
An APK has been provided in a Google Drive link (ask one of our admins for a link)
Or you build the APK on your own by cloning this project, then on the terminal type the following code
        >> flutter build apk
  >> test
<p float="left">
    <img src="/Screenshots/first_screen.png" width="100" />
</p>

## Functionalities
### User Profile
Users can create and register their account from 3 different providers, default Firebase account (email and password), Google and Facebook. Other abilities for users include verifying email address, forgot password, and change profile picture.
<p float="left">
  <img src="/Screenshots/register.png" width="100" />
  <img src="/Screenshots/profile.png" width="100" /> 
</p>

### Map Screen
A map will be displayed in the second tab of Navigation bar.
It will be used to get user's location as starting point. Then, user can also add the destination address (also starting address), followed by the mode of transport. 
Another ability is to get current location button, which will center the Map camera into user's current location.

### Result Screen
Result screen will be displayed after user has inputted all the requirements in Map screen (destination and starting address, and mode of transport). It contains the necessary information from the trip, such as the previous data being inputted by user (addresses and transport), total distance and carbon emission from the trip. Total distance is calculated by finding the shortest route using Google Maps API. Carbon emission is calculated by mmultiplying the carbon factor per km of the distance.

### List of Tips

### Personalised Chart

### History Trips
A screen of past trips will be shown if user press a "previous trip card" located in Home dashboard (Home tab). It will generate a 

### Visualisation

### External Links