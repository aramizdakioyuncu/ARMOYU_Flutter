// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';

class CustomMenus {
  Widget mainbottommenu(int currentIndex, onItemTapped) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Ana Sayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Arama',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Bildirimler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: ARMOYU.color,
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
    );
  }
}
