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
<p float="left">
  <img src="/Screenshots/map.png" width="100" />
</p>

### Result Screen
Result screen will be displayed after user has inputted all the requirements in Map screen (destination and starting address, and mode of transport). It contains the necessary information from the trip, such as the previous data being inputted by user (addresses and transport), total distance and carbon emission from the trip. Total distance is calculated by finding the shortest route using Google Maps API. Carbon emission is calculated by mmultiplying the carbon factor per km of the distance.
Curbon also provide a What-If feature where user can compare other types of transport and its carbon emission. Lastly, 2 tips will be randomly shown and everytime users change the What-If type of transport, another 2 tips will be generated to replace the current tips.
<p float="left">
  <img src="/Screenshots/result.png" width="100" />
</p>

### List of Tips
As mentioned earlier, Curbon aims to raise the awareness of users and guide them how to achieve net zero carbon emission. As a way of doing that, we have provided 2 random tips on Result Screen. However, we decided to provide a way for user to see the list of tips, just in case if they want to show or teach others, take a note for themselves, or other purposes. That is where List of Tips screen play its role. Located in the Profile tab, the last button in the second section (Profile tab can be seen in the screenshot at User Profile section).
<p float="left">
  <img src="/Screenshots/list_tips.png" width="100" />
</p>

### Personalised Chart
Going back to the Home tab, it has 3 different charts at the bottom. We decided that it'd be best to give an overview of user's activity in the last 7 days (including today).The 3 charts represent:
<p float="left">
    (1) the amount of carbon emission per day
    (2) choice of transport 
    (3) total trips per day
</p>
However, we again thought that user may not have the ability to get the summary of those information. Therefore, we created a simple circular chart(but can also act as a button), that represent the summary of the previous 3 charts:
<p float="left">
    (1) total carbon emission for the last 7 days
    (2) most used/chosen type of transport
    (3) total trips for the last 7 days 
</p>
<p float="left">
  <img src="/Screenshots/home.png" width="100" />
</p>
    
### History Trips
A screen of past trips will be shown if user press a "previous trip card" located in Home dashboard (Home tab). It will generate a list of previous trips in a date (descending) order. Meaning, the most recent trip will placed on the top, and user need to scroll down to see the rest of the history. We have provided an ability for the user to delete the unwanted trip. We thought the possibility of users inputting the wrong information or just didn't want that trip to be recorded.
<p float="left">
  <img src="/Screenshots/history.png" width="100" />
</p>

### Visualisation
Invictus Technology is a team based in Melbourne, Australia. In order to support the users knowledge (especially in Australia), we have decided to provide a clear visualisation using open datasets collected from <a href="https://data.gov.au/">here</a>.
The 2 visualisations are generated automatically by downloading the open datasets that we stored safely on Firebase. User will also be given an ability to switch between different variables (using buttons as shown in screenshot)
<p float="left">
  <img src="/Screenshots/vizz_home.png" width="100" />
  <img src="/Screenshots/vizz.png" width="100" />
</p>

### External Links
To provide the users with additional information of our application, we have a dedicated website to host information such as:
<p float="left">
    (1) About us - information about our team, Invictus Technology
    (2) How it works - how the app works, calculation, and everything else
    (3) Ethical and social responsibilities - how do we handle user's privacy and other sensitive information
</p>
By clicking on one of the buttons provided in the Profile tab (shown below), will take the user to our website
<p float="left">
  <img src="/Screenshots/profile.png" width="100" />
</p>