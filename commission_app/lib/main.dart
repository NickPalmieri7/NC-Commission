import 'package:flutter/material.dart';
import 'mlsScreen.dart';
import 'fullAddressScreen.dart';
import 'wideAddressSearch.dart';
import 'selectionPage.dart'; // Import the new SelectionPage

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SelectionPage(), // Initially load SelectionPage
      ),
    );

class HomePage extends StatefulWidget {
  final int initialIndex;

  HomePage({required this.initialIndex});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update current index on swipe
          });
        },
        children: [
          MLSPage(), // Left screen with MLS search
          FullAddressPage(), // Middle screen with full address
          IndividualAddressPage(), // Right screen with individual address fields
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update current index on tap
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'MLS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            label: 'Full Address',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city, color: Colors.white),
            label: 'Individual Address',
          ),
        ],
        selectedItemColor: Colors.white, // Color of selected item
        unselectedItemColor: Colors.white.withOpacity(0.6), // Color of unselected items
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
        type: BottomNavigationBarType.fixed, // Ensure labels are always visible
        // Define the label text style
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
