import 'package:flutter/material.dart';

import 'add_expense_screen.dart';
import 'home_screen.dart';
import 'placeholder_screen.dart';
import 'stats_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    StatsScreen(),
    const PlaceholderScreen(
      title: 'Categories',
      description:
          'Spending buckets and richer category management land after the MVP flow is stable.',
      icon: Icons.grid_view_rounded,
    ),
    const PlaceholderScreen(
      title: 'Accounts',
      description:
          'Multi-account management is intentionally held back while the core expense flow is refined.',
      icon: Icons.wallet_outlined,
    ),
    const PlaceholderScreen(
      title: 'Profile',
      description:
          'Profile settings, preferences, and personalization will be layered in after the first release.',
      icon: Icons.person_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      floatingActionButton: _selectedIndex <= 1
          ? FloatingActionButton(
              onPressed: _openAddExpenseScreen,
              backgroundColor: const Color(0xFF0A6BE8),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add_rounded, size: 34),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0A6BE8),
        unselectedItemColor: const Color(0xFF97A7C1),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline_rounded),
            activeIcon: Icon(Icons.pie_chart_rounded),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_outlined),
            activeIcon: Icon(Icons.wallet_rounded),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<void> _openAddExpenseScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AddExpenseScreen(),
      ),
    );
  }
}
