import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  int selectedIndex;
  BottomBar({this.selectedIndex});
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with AutomaticKeepAliveClientMixin {
  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      if (widget.selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, '/loading_home');
      }
      if (widget.selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, '/loading');
      }
      if (widget.selectedIndex == 2) {
        Navigator.pushReplacementNamed(context, '/visualisation');
      }
      if (widget.selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, '/profile');
      }
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Map'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart),
          title: Text('Chart'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(
              'Profile',
            ))
      ],
      currentIndex: widget.selectedIndex,
      showUnselectedLabels: true,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Color(0xFF26CB7E),
      onTap: _onItemTapped,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
