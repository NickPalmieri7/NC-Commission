import 'package:flutter/material.dart';
import 'fullAddressScreen.dart';
import 'selectionPage.dart'; // Import the new SelectionPage

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SelectionPage(), // Initially load SelectionPage
      ),
    );

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, required this.initialIndex});

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
        children: const [
          FullAddressPage(), // Full address search screen
        ],
      ),
    );
  }
}
