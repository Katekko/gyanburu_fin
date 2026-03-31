import 'package:flutter/material.dart';

/// Maps icon name strings (stored in the database) to Flutter IconData.
const categoryIconMap = <String, IconData>{
  'work': Icons.work,
  'computer': Icons.computer,
  'trending_up': Icons.trending_up,
  'home': Icons.home,
  'bolt': Icons.bolt,
  'directions_car': Icons.directions_car,
  'local_hospital': Icons.local_hospital,
  'movie': Icons.movie,
  'school': Icons.school,
  'restaurant': Icons.restaurant,
  'shopping_bag': Icons.shopping_bag,
  'attach_money': Icons.attach_money,
  'credit_card': Icons.credit_card,
  'pets': Icons.pets,
  'fitness_center': Icons.fitness_center,
  'flight': Icons.flight,
  'phone_android': Icons.phone_android,
  'child_care': Icons.child_care,
  'build': Icons.build,
  'shopping_cart': Icons.shopping_cart,
  'category': Icons.category,
  'pie_chart': Icons.pie_chart,
};

/// Resolves an icon name string to an IconData, with a fallback.
IconData iconForName(String? name) =>
    categoryIconMap[name] ?? Icons.category;
