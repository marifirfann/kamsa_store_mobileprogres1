import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:get/get.dart';
import 'package:kamsa_store/app/admin/katalog/views/katalog_admin_view.dart';
import 'package:kamsa_store/app/modules/pelatihan/views/pelatihan_view.dart';
import 'package:kamsa_store/app/modules/profile/views/profile_view.dart';
class AdminNavbar extends StatefulWidget {
  @override
  _AdminNavbarState createState() => _AdminNavbarState();
}

class _AdminNavbarState extends State<AdminNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    KatalogAdminView(),
    PelatihanView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Pelatihan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
