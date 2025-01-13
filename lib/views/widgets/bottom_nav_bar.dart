import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recipe_app/views/home_page.dart';
import 'package:recipe_app/views/categories_page.dart';
import 'package:recipe_app/views/profile_page.dart';
import 'package:recipe_app/views/add_recipe_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CategoriesPage(),
    Container(), // Placeholder for Add Recipe Page
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, '/add_recipe');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.pinkAccent, // Background color for the navigation bar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Icon
              IconButton(
                icon: Icon(MdiIcons.home,
                    color: _selectedIndex == 0 ? Colors.white : Colors.white70),
                onPressed: () => _onItemTapped(0),
              ),
              // Categories Icon
              IconButton(
                icon: Icon(MdiIcons.grid,
                    color: _selectedIndex == 1 ? Colors.white : Colors.white70),
                onPressed: () => _onItemTapped(1),
              ),
              // Placeholder for Add Button
              SizedBox(width: 40), // Spacing for the floating button
              // Profile Icon
              IconButton(
                icon: Icon(MdiIcons.account,
                    color: _selectedIndex == 3 ? Colors.white : Colors.white70),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
        // Floating Action Button
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_recipe');
        },
        backgroundColor: Colors.white,
        child: Icon(
          MdiIcons.plus,
          color: Colors.pinkAccent,
          size: 32.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
