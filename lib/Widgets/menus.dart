// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';

class CustomMenus {
  Widget mainbottommenu(int currentIndex, onItemTapped) {
    return BottomNavigationBar(
      // backgroundColor: Colors.blue,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
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
          icon: 1 == 1
              ? Icon(Icons.notifications)
              : Stack(
                  children: <Widget>[
                    Icon(Icons.notifications), // Bildirim ikonu
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '15',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
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
