import 'package:flutter/material.dart';
import 'package:mebel_shop/Page/ProductsPage.dart';
import 'package:mebel_shop/Page/ProfilePage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Индекс выбранной вкладки

  // Список страниц для навигации
  final List<Widget> _pages = [
    ProductsPage(),
    ProfilePage(), // Эта страница должна быть создана вами
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Товары',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[700],
        onTap: _onItemTapped,
      ),
    );
  }
}
