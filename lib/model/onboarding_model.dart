import 'package:flutter/material.dart';


class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class ServiceItem {
  final String name;
  final IconData icon;
  final Color color;

  ServiceItem(this.name, this.icon, this.color);
}