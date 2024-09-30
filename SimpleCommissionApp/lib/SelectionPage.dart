import 'package:flutter/material.dart';
import 'main.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/Lighthouse.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
  width: MediaQuery.of(context).size.width * .75,
  padding: const EdgeInsets.all(12),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: AspectRatio(
      aspectRatio: 1.4, // Ensures the image remains square
      child: Image.asset(
        'assets/THELogo.png',
        fit: BoxFit.cover, // Covers the entire area, trimming excess parts
      ),
    ),
  ),
),
                  const SizedBox(height: 36),
                  const Text(
                    "Click the button to continue:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DMSans',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSelectionButton(
                    context,
                    'Buyer Agent Compensation',
                    const HomePage(initialIndex: 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionButton(BuildContext context, String text, Widget page) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'DMSans',
                overflow: TextOverflow.ellipsis, // Ensures text stays on one line
              ),
              maxLines: 1, // Limits the text to one line
              softWrap: false, // Prevents text from wrapping
            ),
          ),
        ),
      ),
    );
  }
}