import 'package:flutter/material.dart';

class ExpenseCategory {
  const ExpenseCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}

const List<ExpenseCategory> expenseCategories = <ExpenseCategory>[
  ExpenseCategory(
    name: 'Food & Dining',
    icon: Icons.restaurant_outlined,
    color: Color(0xFFFFB648),
  ),
  ExpenseCategory(
    name: 'Transportation',
    icon: Icons.directions_bus_outlined,
    color: Color(0xFF61A7FF),
  ),
  ExpenseCategory(
    name: 'Shopping',
    icon: Icons.shopping_bag_outlined,
    color: Color(0xFFFF8C7A),
  ),
  ExpenseCategory(
    name: 'Beauty & Care',
    icon: Icons.auto_awesome_outlined,
    color: Color(0xFFFF72B6),
  ),
  ExpenseCategory(
    name: 'Social',
    icon: Icons.more_horiz_rounded,
    color: Color(0xFF9B8CFF),
  ),
  ExpenseCategory(
    name: 'Travel',
    icon: Icons.flight_takeoff_outlined,
    color: Color(0xFF4BB7A6),
  ),
  ExpenseCategory(
    name: 'Other',
    icon: Icons.widgets_outlined,
    color: Color(0xFF7B8BAA),
  ),
  ExpenseCategory(
    name: 'Accessories',
    icon: Icons.watch_outlined,
    color: Color(0xFF6D8FFF),
  ),
];

ExpenseCategory resolveCategory(String name) {
  return expenseCategories.firstWhere(
    (category) => category.name == name,
    orElse: () => expenseCategories.last,
  );
}
