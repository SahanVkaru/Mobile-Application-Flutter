import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String name;
  final String iconAsset; // or IconData for simplicity
  final double price;
  final IconData iconData; // Using IconData for now to avoid asset dependency issues in mock

  ServiceModel({
    required this.id,
    required this.name,
    required this.price,
    this.iconAsset = '',
    required this.iconData,
  });
}

final List<ServiceModel> mockServices = [
  ServiceModel(
    id: '1',
    name: 'Wash & Fold',
    price: 150.0,
    iconData: Icons.local_laundry_service,
  ),
  ServiceModel(
    id: '2',
    name: 'Dry Cleaning',
    price: 300.0,
    iconData: Icons.dry_cleaning,
  ),
  ServiceModel(
    id: '3',
    name: 'Ironing',
    price: 50.0,
    iconData: Icons.iron,
  ),
  ServiceModel(
    id: '4',
    name: 'Bedding',
    price: 200.0,
    iconData: Icons.bed,
  ),
  ServiceModel(
    id: '5',
    name: 'Shoes',
    price: 400.0,
    iconData: Icons.roller_skating, // Closest match in default icons
  ),
  ServiceModel(
    id: '6',
    name: 'Others',
    price: 100.0,
    iconData: Icons.category,
  ),
];
